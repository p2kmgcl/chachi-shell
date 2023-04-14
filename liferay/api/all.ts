import { createNavigationMenu } from "./requests/navigation-menu.ts";
import { createObject } from "./requests/object.ts";

try {
  await createNavigationMenu();
  await createObject();
} catch (error) {
  if (error instanceof Response) {
    console.log(await error.text());
  } else {
    console.log(error);
  }
}
