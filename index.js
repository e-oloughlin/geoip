import express from 'express';
import maxmind from 'maxmind';

const lookup = await maxmind.open('./GeoLite2-City.mmdb');

const app = express();

app.get('/ip/:ip', async (req, res) => {
	const { ip } = req.params;

	if (!ip) {
		return res.status(400).send('IP address is required');
	}

	if (!maxmind.validate(ip)) {
		return res.status(400).send('Invalid IP address');
	}

	const response = lookup.get(ip);
	return res.json(response);
});

app.listen(3000, () => {
	console.log('Server started on port 3000');
});
