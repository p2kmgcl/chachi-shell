export interface Maybe<T> {
  isSome(): boolean;
  isNone(): boolean;
  unwrap(errorMessage?: string): T;
}

class None implements Maybe<never> {
  private constructor() {}

  public static getInstance() {
    return new None();
  }

  isSome() {
    return false;
  }

  isNone() {
    return true;
  }

  unwrap(errorMessage = 'Option is None'): never {
    throw new Error(errorMessage);
  }
}

class Some<T> implements Maybe<T> {
  constructor(private readonly _value: T) {}

  isSome() {
    return true;
  }

  isNone() {
    return false;
  }

  unwrap() {
    return this._value;
  }
}

export type Option<T> = None | Some<T>;

export const Option = {
  none: None.getInstance(),

  some: function <T>(value: T) {
    return new Some<T>(value);
  },

  fromNullable<T>(value: T | None | Some<T> | null | undefined) {
    if (value instanceof Some || value instanceof None) {
      return value;
    } else if (value === undefined || value === null) {
      return Option.none;
    } else {
      return Option.some<T>(value);
    }
  },
};
