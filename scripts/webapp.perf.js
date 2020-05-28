
const autocannon = require('autocannon');

const {
  env: {
    webapp_url: url, connections = 50, duration = 30, connectionRate = 40,
  },
} = process;

let id = 1;
function setupClient(client) {
  // this is needed for the app service exclusively
  client.setHeaders({
    'Content-Type': 'Application/json',
  });
  client.setBody(JSON.stringify({
    query: `query ($userId: String) {
      getUser(userId: $userId) {
        name {
          last
          first
        }
        location {
          city
          country
          state
        }
        email
      }
    }`,
    variables: { userId: `${id}` },
  }));
  id += 1;
}
autocannon.track(autocannon({
  title: 'Azure Web App GraphQL test',
  method: 'POST',
  url,
  connections,
  duration,
  connectionRate,
  setupClient,
}, console.log), {
  renderLatencyTable: true,
  progressBarString: 'running [:bar] :percent',
});
