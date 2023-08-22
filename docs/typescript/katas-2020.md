https://dev.to/typescript/type-treat-challenge-1-829

## Challenge 1

### Beginner

```ts
// You're making an app which connects to a database
// of local ghosts and their favourite haunts.

// You are creating the client which connects to that database,
// and you have an API response generated for you automatically.

// When you start trying to display the hauntings, you realize
// that you don't know how to type the parameter and just use `any`.

// `any` has its place, but a colleague recommended that you can
// use 'Indexed Types' to remove the 'any' without changing the
// GhostAPIResponse type.

type GhostAPIResponse = {
  name: string;
  birthDate?: string;
  deathDate?: string;
  bio: string;

  hauntings: Array<{ title: string; provenance: string; location: string }>;
};

const displayGhost = (ghost: GhostAPIResponse) => {
  console.log(`Name: ${ghost.name}`);
  if (ghost.birthDate) console.log(`Birthday: ${ghost.birthDate}`);
  if (ghost.deathDate) console.log(`Died: ${ghost.deathDate}`);
  console.log(`\nBio: ${ghost.bio}`);

  console.log(`\nArtworks:`);
  ghost.hauntings.forEach((artwork) => {
    displayHauntings(artwork);
  });
};

// Your goal: remove this any, without changing GhostAPIResponse
// const displayHauntings = (haunting: any) => {
//  console.log(` - Title: ${haunting.title}`)
//  console.log(`   ${haunting.location}`)
//  console.log(`   ${haunting.provemance}`)
// }

const displayHauntings = (haunting: GhostAPIResponse['hauntings'][number]) => {
  console.log(` - Title: ${haunting.title}`);
  console.log(`   ${haunting.location}`);
  console.log(`   ${haunting.provenance}`);
};
```

### Advanced

```ts
// Your kids have returned home with a whole bag
// full of halloween loot, and you've taken the time to
// make a description of all of them:

type SnackBars = {
  name: 'Short Chocolate Bars';
  amount: 4;
  candy: true;
};

type Gumballs = {
  name: 'Gooey Gumballs';
  color: 'green' | 'purples';
  candy: true;
};

type Apples = {
  name: 'Apples';
  candy: true;
};

type Cookies = {
  name: 'Cookies';
  candy: true;
  peanuts: true;
};

type SnickersBar = {
  name: 'Snickers Bar';
  candy: true;
  peanuts: true;
};

type Toothpaste = {
  name: 'Toothpaste';
  minty: true;
  trick: true;
};

type Pencil = {
  name: 'Pencil';
  trick: true;
};

// You create a single pile of all the results, and want to use
// this to share out the winnings among your kids.

type ResultsFromHalloween =
  | SnackBars
  | Gumballs
  | Apples
  | SnickersBar
  | Cookies
  | Toothpaste
  | Pencil;

// You're first going to need to separate out the candy from the treats,
// you can do that via conditional types.

// type AllCandies = ...
// type AllTricks = ...

// Almost there, but little 'Bobby Tables' cannot have peanuts. Can
// you make a list of candies just for him?

// type AllCandiesWithoutPeanuts = ...

type AllCandies = Extract<ResultsFromHalloween, { candy: true }>;
type AllTricks = Extract<ResultsFromHalloween, { trick: true }>;
type AllCandiesWithoutPeanuts = Exclude<AllCandies, { peanuts: true }>;
```

## Challenge 2

### Beginner

```ts
// You have a very special pumpkin, and you want to create a type from it.

// Traditionally speaking, you could define a type or interface
// for the shape, but you are only going to have this one pumpkin,
// so you don't feel like it's worth duplicating the definition.

const pumpkin = {
  color: 'yellowish',
  type: 'gourd',
  size: 'Medium',
  energy: '109 Kj per 100g',
  flowered: false,
  sizeCM: '50.8 x 40.6 x 30.2 cm',
};

// Instead of creating a type like:
//
// type Pumpkin = {
//   color: string
//   ...
// }
//
// Can you you use typeof types to create a single liner?

// type Pumpkin = any
type Pumpkin = typeof pumpkin;

// Next up, research how you can use a utility type to handle
// the same problem with a function. How can you extract the
// return type from this function to get the same type?

const createExamplePumpkin = () => {
  return pumpkin;
};

// type PumpkinFromFunction = any
type PumpkinFromFunction = ReturnType<typeof createExamplePumpkin>;
```

### Advanced

```ts
// It's been quite an evening, someone let out all
// the ghosts you've been catching for your first year in
// business. That's not even the worst bit though,
// it turns out gods and demons are also real
// and are now all over Manhattan.

// The brains of your team has come up with an algorithm
// for dealing with the problem. They assert this algorithm
// is the only way in which you can deal with the issue.

// They have set up a list of reported ghosts/demons/gods
// and have asked if you can fill in some of the details
// at the bottom but not change their code.

// Stay on your guard.

type Vigo = {
  name: 'Vigo Von Homburg Deutschendorf';
  born: 'Moldova';
  humanIsh: true;
};

type Zuul = {
  name: 'Zuul';
  demon: true;
  sendBackToHell(): void;
};

type Vinz = {
  name: 'Vinz Clortho';
  demon: true;
  sendBackToHell(): void;
};

type Gizer = {
  name: 'Vinz Clortho';
  god: true;
  hijackStayPuffMan(): void;
};

type Slimer = {
  name: 'Slimer';
  color: 'Green-y see through';
  ectoplasmic: true;
};

type Ghosts = Vigo | Zuul | Vinz;

declare function shockAndTrap(ghosts: Array<{ ectoplasmic: true }>): void;

/** @deprecated - this is bad advice */
declare function crossTheStreams(): void;

function investigateReport(ghosts: Ghosts[]) {
  if (areGods(ghosts)) {
    // Unsure if is the right thing to do
    // but it could work
    crossTheStreams();
    return;
  }

  // Tricky but something I think we can
  // handle on a case-by-case basis
  if (areDemons(ghosts)) {
    for (const demon of ghosts) {
      demon.sendBackToHell();
    }
  }

  // We've done this a lot now,
  // shouldn't be too difficult
  if (areEctoPlasmic(ghosts)) {
    shockAndTrap(ghosts);
  }
}

// OK, this is the end of code which can't change.
// Can you write functions below which will let the above
// code compile? It's looking pretty serious out there.

// Good luck. Stay on your guard.

// type GodGhost = Ghosts & { god: true };
type GodGhost = Extract<Ghosts, { god: true }>;
declare function areGods(ghosts: Ghosts[]): ghosts is GodGhost[];

// type DemonGhost = Ghosts & { demon: true; sendBackToHell(): void };
type DemonGhost = Extract<Ghosts, { demon: true }>;
declare function areDemons(ghosts: Ghosts[]): ghosts is DemonGhost[];

// type EctoplasmicGhost = Ghosts & { ectoplasmic: true };
type EctoplasmicGhost = Extract<Ghosts, { ectoplasmic: true }>;
declare function areEctoPlasmic(ghosts: Ghosts[]): ghosts is EctoplasmicGhost[];
```

## Challenge 3

### Beginner

```ts
// You've been keeping a diary of your trick or treat
// results for your street, they generally fall into
// three categories: treats, tricks and no-shows.

// Can you make three types which can describe of
// these results?

const treats = [
  { location: 'House 1', result: 'treat', treat: { candy: 'Lion Bar' } },
  { location: 'House 3', result: 'treat', treat: { candy: 'Mars Bar' } },
  {
    location: 'House 4',
    result: 'treat',
    treat: { baked: 'Cookies', candy: "Reese's" },
  },
] satisfies Treat[];

const tricks = [
  { location: 'House 2', result: 'trick', trick: 'Magic' },
  { location: 'House 7', result: 'trick', trick: 'Surprised' },
] satisfies Trick[];

const noShows = [{ location: 'House 6', result: 'no-show' }] satisfies NoShow[];

// type Treat = { location: string, result: 'treat', treat: { candy: string, baked?: string } };
// type Trick = { location: string, result: 'trick', trick: string };
// type NoShow = { location: string, result: 'no-show' };

// Now that you have the types, can you make them
// not duplicate 'location' and 'result' by using
// a union for 'result' and a new intersection type?

type Result<T extends string> = { location: `House ${number}`; result: T };
type Treat = Result<'treat'> & { treat: { candy: string; baked?: string } };
type Trick = Result<'trick'> & { trick: string };
type NoShow = Result<'no-show'>;
```

### Advanced

```ts
// Dang, COVID19 has really put a bind on the nature of trick or treating.
// Your block has opt-ed to instead do a trunk or treat instead.

// In a rush to prepare for the event, you hardcoded the
// results into the 'TrunkOrTreatResults' type which is already
// out of date - it's missing a few properties!
// Can you rewrite 'TrunkOrTreatResults' as an object type that
// stays in sync with the strings in 'trunkOrTreatSpots'?

const trunkOrTreatSpots = [
  'The Park',
  'House #1',
  'House #2',
  'Corner Shop',
  'Place of Worship',
] as const;

// type TrunkOrTreatResults = {
//     "The Park": {
//         done: boolean,
//         who: string,
//         loot: Record<string, any>
//     },
//     "House #1" : {
//         done: boolean,
//         who: string,
//         loot: Record<string, any>
//     },
//     "House #2": {
//         done: boolean,
//         who: string,
//         loot: Record<string, any>
//     }
// }

type TrunkOrTreatResults = Record<
  (typeof trunkOrTreatSpots)[number],
  {
    done: boolean;
    who: string;
    loot: Record<string, any>;
  }
>;

function makeTODO(spots: typeof trunkOrTreatSpots): TrunkOrTreatResults {
  return spots.reduce((prev, current) => {
    return {
      ...prev,
      [current]: {
        done: false,
        loot: {},
        who: '',
      },
    };
  }, {} as TrunkOrTreatResults);
}

// You can preview the results via "Run" above

const todo = makeTODO(trunkOrTreatSpots);
console.log(todo);

// Works
todo['The Park'].done = true;

// Should Work
todo['Corner Shop'].loot = {};

// Fails
todo['House #3'].done = false;
```

## Challenge 4

### Beginner

```ts
// No-one knows what is going on, but you think your workplace
// is haunted by a poltergeist. It kinda sucks.
//
// Your objects keep getting changed behind the scenes,
// stop this from happening by making your objects readonly
// to stop this spooky behavior.

type Rectory = {
  rooms: Room[];
  noises: any[];
};

type Room = {
  name: string;
  doors: number;
  windows: number;
  ghost?: any;
};

// http://www.unexplainedstuff.com/Ghosts-and-Phantoms/Famous-Haunted-Houses-and-Places-Epworth-rectory.html
const epworthRectory = {
  // https://epwortholdrectory.org.uk/epworth-old-rectory-old/visit/virtual-tour/
  rooms: [
    { name: 'Entrance Hall', doors: 5, windows: 2 },
    { name: 'The Kitchen', doors: 2, windows: 3 },
    { name: 'Parlour', doors: 2, windows: 3 },
    { name: 'The Nursery', doors: 2, windows: 3 },
    { name: 'The Attic', doors: 2, windows: 1 },
    { name: 'The Study', doors: 2, windows: 2 },
    { name: 'Master Bedroom', doors: 1, windows: 4 },
    { name: 'Bedroom 2', doors: 2, windows: 3 },
  ],
};

// This code should cause compiler errors
// function haunt(rectory: Rectory) {
//   const room = rectory.rooms[Math.floor(Math.random() * rectory.rooms.length)];
//   room.ghost = { name: "Old Jeffrey" }
// }

type DeepFreeze<T> = T extends Record<any, any>
  ? Readonly<{ [k in keyof T]: DeepFreeze<T[k]> }>
  : Readonly<T>;

function haunt(rectory: DeepFreeze<Rectory>) {
  const room = rectory.rooms[Math.floor(Math.random() * rectory.rooms.length)];
  room.ghost = { name: 'Old Jeffrey' };
}
```

### Advanced

```ts
// You got roped into the cutest halloween competition, judging
// doggy halloween pet costumes at the annual parade.

declare function decideWinner(
  breed: string,
  costume: string,
): { name: string; video: string };
window.decideWinner = someoneElseDecides;

// Oh, actually you didn't - someone else got to do the fun bit...
// Though you can watch it on zoom: http://www.tompkinssquaredogrun.com/halloween

// Instead, you've been asked to help tally up a scoreboard of the most
// popular costumes according to the most popular breeds. You've built
// out a quick implementation below, but it loses type information.

// Now the contest is over, you feel it's your duty to refactor this
// code to retain type information - you've heard that the 4.1 beta includes
// something which helps with typing string manipulation.

const breeds = ['Hound', 'Corgi', 'Pomeranian'] as const;
const costumes = ['Pumpkin', 'Hot Dog', 'Bumble Bee'] as const;

type WinnerKey =
  Lowercase<`${(typeof breeds)[number]}-${(typeof costumes)[number]}`>;

function tallyPopularWinners(
  _breeds: typeof breeds,
  _costumes: typeof costumes,
) {
  const winners: { [k in WinnerKey]?: any } = {};

  for (const breed of _breeds) {
    for (const costume of _costumes) {
      const id = `${breed}-${costume}`.toLowerCase() as WinnerKey;
      winners[id] = decideWinner(breed, costume);
    }
  }

  return winners;
}

// You can run this example in order to see what the shape of the data looks like, but
// the result will have keys which are lowercased for every mix of breed and costume, e.g:

// {
//     "hound-pumpkin": {...},
//     "hound-hot dog": {...},
//     "hound-bumble bee": {...},
//     "corgi-pumpkin": {...}
//     ...
// }

const winners = tallyPopularWinners(breeds, costumes);
console.log(winners);

// Passes
winners['hound-pumpkin'].name;

// Should fail
winners['pumpkin-pumpkin'].video;
```

## Challenge 5

### Beginner

```ts
// We have a set of houses on a street which
// gives out candy and occasionally needs re-stocking.

// This is an accurate representation of the houses
// but there's a lot of duplicated code in here, and
// you want to create a type which could represent
// any house.

// It looks like the only thing which changes between
// houses is the return value of `trickOrTreat` and
// the first parameter of `restock`.

// Can you use a generic type to make a `House` type
// which has a single argument for the return value
// of `trickOrTreat` and the param to `restock`?

type House<T> {
  doorNumber: number;
  trickOrTreat(): T;
  restock(items: T): void;
}

// type FirstHouse = {
//   doorNumber: 1;
//   trickOrTreat(): "book" | "candy";
//   restock(items: "book" | "candy"): void;
// };

// type SecondHouse = {
//   doorNumber: 2;
//   trickOrTreat(): "toothbrush" | "mints";
//   restock(items: "toothbrush" | "mints"): void;
// };

// type ThirdHouse = {
//   doorNumber: 3;
//   trickOrTreat(): "candy" | "apple" | "donuts";
//   restock(items: "candy" | "apple" | "donuts"): void;
// };

// type FourthHouse = {
//   doorNumber: 4;
//   trickOrTreat(): "candy" | "spooky spiders";
//   restock(items: "candy" | "spooky spiders"): void;
// };

type FirstHouse = House<'book' | 'candy'>;
type SecondHouse = House<'toothbrush' | 'mints'>;
type ThirdHouse = House<'candy' | 'apple' | 'donuts'>;
type FourthHouse = House<'candy' | 'spooky spiders'>;

type Street = [FirstHouse, SecondHouse, ThirdHouse, FourthHouse];
```

### Advanced

```ts
// You're part of a team scheduling a movie night, but someone accidentally
// considered the movie "The Nightmare Before Christmas" to be a halloween
// movie, which it really isn't.

const moviesToShow = {
  halloween: { forKids: false },
  nightmareOnElmStreet: { forKids: false },
  hocusPocus: { forKids: true },
  theWorstWitch: { forKids: true },
  sleepyHollow: { forKids: false },
} as const;

type Writable<T> = { -readonly [k in keyof T]: Writable<T[k]> };
type Movies = typeof moviesToShow;

type KidsMovies = {
  [k in keyof Movies as Movies[k]['forKids'] extends true
    ? k
    : never]: Movies[k];
};

type MovieAction<MovieName extends string> =
  | `getVHSFor${Capitalize<MovieName>}`
  | `makePopcornFor${Capitalize<MovieName>}`
  | `play${Capitalize<MovieName>}`;

type MoviesSchedule<T> = {
  [k in keyof T as k extends string ? MovieAction<k> : never]: () => void;
};

// They got away with this travesty because you have some `any`s in the
// codebase for creating the scheduler. An OK call for a first pass, but
// we're sharing code with others and want to be explicit.

function makeScheduler(movies: typeof moviesToShow) {
  const schedule: Partial<MoviesSchedule<Writable<KidsMovies>>> = {};

  for (const movie in Object.keys(movies)) {
    const capitalName = (movie.charAt(0).toUpperCase() +
      movie.slice(1)) as Capitalize<keyof KidsMovies>;

    schedule[`getVHSFor${capitalName}`] = () => {};
    schedule[`makePopcornFor${capitalName}`] = () => {};
    schedule[`play${capitalName}`] = () => {};
  }

  return schedule as MoviesSchedule<KidsMovies>;
}

// Creates a scheduler
const movieNight = makeScheduler(moviesToShow);

// Then all these functions are automatically created
movieNight.getVHSForHalloween();
movieNight.makePopcornForHalloween();
movieNight.playHalloween();

// Not a halloween movie! This should be a compiler error
movieNight.getVHSForNightmareBeforeChristmas();
movieNight.makePopcornForNightmareBeforeChristmas();
movieNight.playNightmareBeforeChristmas();

movieNight.getVHSForHocusFocus();
movieNight.makePopcornForHocusPocus();
movieNight.playHocusPocus();
```
