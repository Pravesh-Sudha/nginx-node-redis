const os = require('os');
const express = require('express');
const app = express();
const redis = require('redis');

// Create Redis client
const redisClient = redis.createClient({
  host: 'redis',
  port: 6379
});

app.get('/', function (req, res) {
  redisClient.get('numVisits', function (err, numVisits) {
    let numVisitsToDisplay = parseInt(numVisits) + 1;
    if (isNaN(numVisitsToDisplay)) {
      numVisitsToDisplay = 1;
    }

    // Update Redis
    redisClient.set('numVisits', numVisitsToDisplay);

    // Send attractive HTML response
    res.send(`
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <title>Visit Counter</title>
        <style>
          body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to right, #1e3c72, #2a5298);
            color: #fff;
            text-align: center;
            padding: 50px;
          }
          .card {
            background: rgba(255, 255, 255, 0.1);
            padding: 30px;
            border-radius: 12px;
            display: inline-block;
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
          }
          h1 {
            font-size: 2.5rem;
            margin-bottom: 20px;
          }
          p {
            font-size: 1.3rem;
            margin: 10px 0;
          }
          .highlight {
            font-weight: bold;
            font-size: 1.5rem;
            color: #ffd700;
          }
        </style>
      </head>
      <body>
        <div class="card">
          <h1>🌍 Welcome to Request Counter</h1>
          <p>Running on: <span class="highlight">${os.hostname()}</span></p>
          <p>Total Visits: <span class="highlight">${numVisitsToDisplay}</span></p>
        </div>
      </body>
      </html>
    `);
  });
});

app.get('/health', function (req, res) {
  res.status(200).send('OK');
});

app.listen(5000, function () {
  console.log('🌐 Web application is listening on port 5000');
});
