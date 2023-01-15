import maxmind from 'maxmind';

const lookup = await maxmind.open('./GeoLite2-City.mmdb');

export const handler = (event) => {
  const { ip } = event;

  if (!ip) {
    return Promise.resolve({
      status: 406,
      message: 'IP address is required'
    });
	}

  if (!maxmind.validate(ip)) {
    return Promise.resolve({
      status: 404,
      message: 'Invalid IP address'
    });
	}

  return Promise.resolve(lookup.get(ip));
}
