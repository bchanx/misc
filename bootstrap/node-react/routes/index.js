import express from 'express';

let router = express.Router();

router.get('/status', function(req, res) {
  res.send({
    env: req.app.get('env'),
    port: req.app.get('port'),
    locals: req.app.locals
  });
});

export default router;
