// const express = require('express');
// const app = express();
// const port = 3000;

// app.get('/health', (req, res) => {
//     res.status(200).send('OK');
// });

// app.listen(port, () => {
//     console.log(`Frontend app listening at http://www.cloudeof.com:${port}`);
// });

const express = require('express');
const path = require('path');
const app = express();
const port = 3000;

// 정적 파일 제공
app.use(express.static(path.join(__dirname, 'build')));

// Health check 엔드포인트
app.get('/health', (req, res) => {
    res.status(200).send('OK');
});

// 모든 요청에 대해 React 앱 제공
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'build', 'index.html'));
});

app.listen(port, () => {
    console.log(`Frontend app listening at http://www.cloudeof.com:${port}`);
});
