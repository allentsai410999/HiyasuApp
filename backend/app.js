const express = require('express');
const db = require('./db');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.get('/api/query/:database', (req, res) => {
    const dbName = req.params.database;
    // Logic to query the 正航資料庫
    res.send(`Querying database ${dbName}`);
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});