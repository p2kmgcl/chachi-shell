# Learning JavaScript

## JavaScript vs Web APIs

The JavaScript language is defined by the ECMAScript specification. Which is
updated once a year since the famous ES2015 (or ES6) release. The specification
defines different parts of JavaScript including the language syntax itself and
the standard APIs that are implemented by JavaScript engines. We should take
into account that these APIs are **not** related to the DOM specification or the
Web APIs, which are designed for specific purposes like web applications.

The official specification can be found at the [tc39 website](https://tc39.es/),
but most times this is hard to read. The
[Mozilla Developer Network (MDN)](https://developer.mozilla.org) however is a
good place to find documentation about JavaScript, and all web-related
resources. This is officially maintained by Mozilla, but accepts wiki-like
contributions from anyone.

There are other sites that also have JavaScript, but we should be careful when
checking them for different reasons:

- [W3CSchools](https://www.w3schools.com/) is not related with the W3C group at
  all, and takes it's name to get some good scores in search engines. However
  it's documentation is generally a bit outdated and doesn't cover all the
  specification.
- The [web.dev](https://web.dev) site is an awesome initiative from Google to
  create a documentation site with not only references but also articles and
  recommendations. In general this site is really well written, but they do not
  give information about browser/engine compatibility. They focus on features
  that are available in Chrome and Blink (Chrome's JS engine) and might not be
  part of the specification yet.

That said, reading the
[MDN JavaScript tutorial](https://developer.mozilla.org/en-US/docs/Web/JavaScript)
is highlight recommended as it goes through many aspects of the language without
mixing it (too much) with browser-related details.

## TypeScript

JavaScript typing system is weak and dynamic, a variable can be assigned with
any type and the JS engine will try to convert it's value to any other type
needed when doing operations. This has historically caused lots of jokes about
situations caused by it (ex. the
[wat](https://www.destroyallsoftware.com/talks/wat) talk), but it can also cause
lots of headaches when maintaining a large JavaScript application. JS developers
have tried to rely on [JSDoc](https://jsdoc.app/) to have some kind of
typechecking, but there have never been tools that really enforce strong typing
with this system.

TypeScript proposal is creating a whole new language with a strong type system,
which actually needs to be compiled to JavaScript before being executed (there
are already engines that support executing both JS and TS like
[Deno](https://deno.com/) or [Bun](https://bun.sh/), but browsers can't). During
this compilation process, the TypeScript engine checks the typings of all code
and it removes them to generate JS, because TS has actually almost the same
syntax as JS.

```js
function add(a, b) {
  return a + b;
}
```

```ts
function add(a: number, b: number) {
  return a + b;
}
```

The
[official TypeScript documentation](https://www.typescriptlang.org/docs/handbook/intro.html)
is actually a good start point to start learning this type system. It introduces
some concepts like interfaces and generics, which don't exist in JS.

[Matt Pocock youtube channel](https://www.youtube.com/@mattpocockuk/videos) is
also full of videos explaining some interesting things about TypeScript.
