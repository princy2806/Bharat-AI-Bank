Client Site - Agentforce Hackathon

Local preview:
1. From this repository root, open the file uiBundles/clientSite/src/index.html in a browser.
2. Or run a simple static server, for example (requires Python):
   - python -m http.server --directory uiBundles/clientSite/src 8000
   - Open http://localhost:8000

Contents:
- src/index.html — entry
- src/main.js — minimal SPA router and pages
- src/styles.css — basic styling
- ui-bundle.json — bundle config (for build/packaging)
- clientSite.uibundle-meta.xml — metadata for Salesforce deployment

Salesforce deployment:
- Package the folder uiBundles/clientSite into a DigitalExperienceBundle or use the Salesforce UI Bundles tooling.
- If you plan to host as an Experience Cloud site, you'll need to create a DigitalExperienceBundle metadata and reference these assets, or deploy the generated bundle output into the static resources / site files depending on your org setup.

Next steps I can perform:
- Integrate with Salesforce data endpoints (use SDK or GraphQL)
- Add authentication and protected routes
- Convert to a React app (Vite) and wire CI/CD