#!/usr/bin/env -S deno run --allow-net --allow-read

const HOST = 'localhost';
const FROM_PORT = 9090;
const TO_PORT = 8080;

// const BASE_PATH = '/home/p2kmgcl/Projects/community-portal/liferay-portal/modules/apps/layout/layout-content-page-editor-web/build/patata/src/main/resources/META-INF/resources';
// const PREFIX_PATH = 'NONONO/o/js/resolved-module/@liferay/layout-content-page-editor-web@3.0.175';

const listener = Deno.listen({ port: FROM_PORT });
console.log(`Ready http://localhost:${FROM_PORT}`);

for await (const connection of listener) {
  onConnection(connection);
}

async function onConnection(connection: Deno.Conn) {
  const httpConnection = Deno.serveHttp(connection);

  for await (const requestEvent of httpConnection) {
    onRequest(requestEvent);
  }
}

async function onRequest(requestEvent: Deno.RequestEvent) {
  console.log(requestEvent.request.url);

  const requestURL = new URL(requestEvent.request.url);
  requestURL.port = TO_PORT.toString();

  const proxyRequest = new Request(requestURL, requestEvent.request);
  let proxyResponse = await fetch(proxyRequest);

  // Pick updated code from page editor
  // if (requestURL.pathname.includes(PREFIX_PATH)) {
  //   try {
  //     const filePath = requestURL.pathname.replace(PREFIX_PATH, BASE_PATH);
  //     const fileContent = await Deno.readTextFile(filePath);
  //     proxyResponse = new Response(fileContent, proxyResponse);
  //   } catch (_error) {}
  // }

  // Replace all references to the original host to the proxy
  if (proxyResponse.headers.get('Content-Type')?.includes('UTF-8')) {
    const text = await proxyResponse.clone().text();

    proxyResponse = new Response(
      text.replaceAll(`${HOST}:${TO_PORT}`, `${HOST}:${FROM_PORT}`),
      proxyResponse,
    );
  }

  requestEvent.respondWith(proxyResponse);
}
