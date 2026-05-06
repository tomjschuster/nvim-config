#!/usr/bin/env node

import { createServer } from "node:http";
import { spawn } from "node:child_process";

const PORT = process.env.PORT || 8082;

function toErrorResponse(message) {
  return {
    id: `msg_${Date.now()}`,
    type: "message",
    role: "assistant",
    model: "claude-sonnet-4-6",
    content: [{ type: "text", text: JSON.stringify({ error: message, placement: "chat" }) }],
    stop_reason: "end_turn",
    stop_sequence: null,
    usage: { input_tokens: 0, output_tokens: 0 },
  };
}

function log(...args) {
  console.log(`[${new Date().toISOString()}]`, ...args);
}

function formatPrompt(messages) {
  return messages
    .map((m) => {
      const role = m.role === "assistant" ? "Assistant" : "Human";
      let content;
      if (typeof m.content === "string") {
        content = m.content;
      } else {
        content = m.content
          .filter((b) => b.type === "text")
          .map((b) => b.text)
          .join("\n");
      }
      return `${role}: ${content}`;
    })
    .join("\n\n");
}

function callClaude(prompt, systemPrompt) {
  return new Promise((resolve, reject) => {
    const args = [
      "-p",
      "--output-format", "json",
      "--max-turns", "1",
      "--allowed-tools", "",
    ];
    if (systemPrompt) args.push("--system-prompt", systemPrompt);

    log("Spawning claude with args:", JSON.stringify(args.slice(0, -1)));
    log("Prompt (first 200 chars):", prompt.slice(0, 200));

    const proc = spawn("claude", args, {
      env: { ...process.env, CLAUDECODE: undefined },
      stdio: ["pipe", "pipe", "pipe"],
    });

    proc.stdin.write(prompt);
    proc.stdin.end();

    let stdout = "";
    let stderr = "";
    proc.stdout.on("data", (d) => {
      stdout += d;
      log("claude stdout chunk:", d.toString().slice(0, 200));
    });
    proc.stderr.on("data", (d) => {
      stderr += d;
      log("claude stderr:", d.toString().slice(0, 200));
    });
    proc.on("close", (code) => {
      log("claude exited with code:", code);
      log("claude full stdout:", stdout.slice(0, 500));
      if (code !== 0) return reject(new Error(stderr || `exit ${code}`));
      try {
        resolve(JSON.parse(stdout));
      } catch {
        resolve({ result: stdout.trim() });
      }
    });
    proc.on("error", (err) => {
      log("claude spawn error:", err.message);
      reject(err);
    });
  });
}

// Extract the first valid JSON object from text
function extractJson(text) {
  try {
    JSON.parse(text);
    return text;
  } catch {}

  // Walk through every '{' and try to parse from there
  for (let i = 0; i < text.length; i++) {
    if (text[i] !== "{") continue;
    // Try progressively longer substrings ending at each '}'
    for (let j = text.indexOf("}", i); j !== -1; j = text.indexOf("}", j + 1)) {
      const candidate = text.slice(i, j + 1);
      try {
        JSON.parse(candidate);
        return candidate;
      } catch {}
    }
  }

  return text;
}

function toAnthropicResponse(cliResult) {
  const raw = cliResult.result;
  if (!raw) {
    log("WARNING: no result field in CLI output, keys:", Object.keys(cliResult));
    return toErrorResponse("No result from Claude CLI");
  }

  let text = typeof raw === "string" ? raw : JSON.stringify(raw);
  text = extractJson(text.trim());

  log("Cleaned result text:", text.slice(0, 300));

  return {
    id: `msg_${Date.now()}`,
    type: "message",
    role: "assistant",
    model: "claude-sonnet-4-6",
    content: [{ type: "text", text }],
    stop_reason: "end_turn",
    stop_sequence: null,
    usage: {
      input_tokens: cliResult.usage?.input_tokens || 0,
      output_tokens: cliResult.usage?.output_tokens || 0,
    },
  };
}

const server = createServer(async (req, res) => {
  log(`${req.method} ${req.url}`);

  if (req.method !== "POST" || !req.url.endsWith("/messages")) {
    log("Rejected: not a POST to /messages");
    res.writeHead(404);
    return res.end("Not found");
  }

  let body = "";
  for await (const chunk of req) body += chunk;

  log("Request body (first 500):", body.slice(0, 500));

  try {
    const payload = JSON.parse(body);
    const prompt = formatPrompt(payload.messages || []);
    const system =
      typeof payload.system === "string"
        ? payload.system
        : Array.isArray(payload.system)
          ? payload.system
              .filter((b) => b.type === "text")
              .map((b) => b.text)
              .join("\n")
          : undefined;

    // Log each message individually
    for (const [i, m] of (payload.messages || []).entries()) {
      const c = typeof m.content === "string" ? m.content : m.content?.map((b) => b.text || `[${b.type}]`).join(" ");
      log(`Message[${i}] role=${m.role} content(first 150)=`, (c || "").slice(0, 150));
    }
    log("Prompt length:", prompt.length, "System prompt length:", system?.length || 0);

    const result = await callClaude(prompt, system);
    log("Claude result keys:", Object.keys(result));

    const response = toAnthropicResponse(result);
    log("Sending response, text length:", response.content[0].text.length);

    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify(response));
  } catch (err) {
    log("ERROR:", err.message);
    res.writeHead(500, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ error: { type: "server_error", message: err.message } }));
  }
});

server.listen(PORT, "127.0.0.1", () => {
  log(`Claude proxy listening on http://127.0.0.1:${PORT}`);
});
