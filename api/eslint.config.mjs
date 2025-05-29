import js from "@eslint/js";
import globals from "globals";
<<<<<<< HEAD
import tseslint from "typescript-eslint";
=======
>>>>>>> upstream/main
import { defineConfig } from "eslint/config";


export default defineConfig([
  { files: ["**/*.{js,mjs,cjs}"], plugins: { js }, extends: ["js/recommended"] },
  { files: ["**/*.js"], languageOptions: { sourceType: "commonjs" } },
  { files: ["**/*.{js,mjs,cjs}"], languageOptions: { globals: {...globals.browser, ...globals.node} } },
<<<<<<< HEAD
  tseslint.configs.recommended,
]);
=======
]);
>>>>>>> upstream/main
