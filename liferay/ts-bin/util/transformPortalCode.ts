const MODULE_NAME = '@liferay/layout-content-page-editor-web';
const MODULE_VERSION = '3.0.175';
import { parse, print, visit } from 'npm:recast@0.23.4';

export function transformPortalCode(fileId: string, code: string) {
  return print(
    visit(parse(code), {
      visitCallExpression(path) {
        if (path.node.callee.name !== 'define') {
          return false;
        }

        path.node.callee.name = 'Liferay.Loader.define';

        const [dependencies, callback] = path.node.arguments;

        dependencies.elements.at(0).value = 'module';

        dependencies.elements.splice(2, 0, {
          type: 'Literal',
          value: 'require',
        });

        const body = callback.body.body;

        const declarations = callback.params.splice(2);
        callback.params.at(0).name = 'module';
        callback.params.push({ type: 'Identifier', name: 'require' });

        for (let i = 0; i < declarations.length; i++) {
          const declaration = declarations[i];

          body.splice(0, 1);

          body.splice(1, 0, {
            type: 'VariableDeclaration',
            kind: 'const',
            declarations: [
              {
                type: 'VariableDeclarator',
                id: declaration,
                // init: {
                //   type: 'CallExpression',
                //   callee: '_interopRequireDefault',
                //   arguments: [
                //     {
                //       type: 'CallExpression',
                //       callee: 'require',
                //       arguments: [
                //         {
                //           type: 'Literal',
                //           value: dependencies.elements[i + 3].value,
                //         },
                //       ],
                //     },
                //   ],
                // },
                init: {
                  type: 'CallExpression',
                  callee: 'require',
                  arguments: [
                    {
                      type: 'Literal',
                      value: dependencies.elements[i + 3].value,
                    },
                  ],
                },
              },
            ],
          });
        }

        path.node.arguments.unshift({
          type: 'Literal',
          value: `${MODULE_NAME}@${MODULE_VERSION}${fileId}`,
        });

        return false;
      },
    }),
  ).code;
}
