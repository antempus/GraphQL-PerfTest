
const autocannon = require('autocannon');

const {
  env: {
    functionapp_url: url, connections = 50, duration = 30, connectionRate = 40,

  },
} = process;

let id = 0;
function setupClient(client) {
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
  title: 'Azure Function App GraphQL test',
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
