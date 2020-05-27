const { env: { functionapp_url: url } } = require('process');
const axios = require('axios');
const users = require('./users.json');


async function populate() {
  return axios.post(url, users);
}

async function main() {
  console.log('populating users');
  await populate().then(() => console.log('users populated')).catch((error) => console.log(error));
}

main();
