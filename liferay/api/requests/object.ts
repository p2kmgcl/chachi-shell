import {
  ObjectDefinition,
  ObjectFieldBusinessType,
  ObjectFieldDbType,
} from "../types/generated/object-admin-openapi.ts";
import { api } from "../util/api.ts";

const OBJECT_ERC = "generated-object-definition";

export async function createObject() {
  try {
    const object = await api.objectAdmin.v10
      .getObjectDefinitionByExternalReferenceCode(OBJECT_ERC).then((r) =>
        r.json() as ObjectDefinition
      );
    await api.objectAdmin.v10.deleteObjectDefinition(
      object.id as unknown as string,
    );
  } catch (error) {}

  const object = await api.objectAdmin.v10.postObjectDefinition({
    externalReferenceCode: OBJECT_ERC,
    defaultLanguageId: "en_US",
    active: true,
    scope: "company",
    panelCategoryKey: "Applications > Content",
    id: OBJECT_ERC as unknown as number,
    name: "Ticket",
    label: { en_US: "Ticket" },
    pluralLabel: { en_US: "Tickets" },
    objectFields: [
      {
        name: "eventName",
        required: false,
        label: { en_US: "Event name" },
        DBType: ObjectFieldDbType.String,
        businessType: ObjectFieldBusinessType.Picklist,
      },
    ],
  }).then((r) => r.json() as ObjectDefinition);

  await api.objectAdmin.v10.postObjectDefinitionPublish(
    object.id as unknown as string,
  );
}
