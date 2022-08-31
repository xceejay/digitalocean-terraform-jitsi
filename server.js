var express = require("express");
var app = express();
var redis = require("redis");
var client = redis.createClient(); //creates a new client
var randomWords = require("random-words");
const { exec } = require("child_process");
var uniqid = require("uniqid");

const PASS = "youtube@X123";
// READ these articles to help you run SHELL commands in this JS script
// https://stackoverflow.com/questions/20643470/execute-a-command-line-binary-with-node-js
// https://riptutorial.com/node-js/example/9105/spawning-a-shell-to-execute-a-command
// https://stackabuse.com/executing-shell-commands-with-node-js/

app.listen(3000, () => {
  console.log("Terraform Server running on port 3000");
});

// Root endpoint
app.get("/", (req, res, next) => {
  res.json(randomWords());
});

// Setup recorder for domain
app.get("/setup-recorders", (req, res) => {
  // TODO: @xceejay SHELL command to spawn new recorders for a given domain.
  let domain = req.query.domain;
  let password = req.query.password;

  console.log("Pass " + password);
  console.log("Domain " + domain);

  let random = uniqid();
  if (password == PASS) {
    var command = `cd digitalocean-jibri; tmux new-session -d -s "${random}"  "./deploy.sh ${domain}"`;

    exec(command, (err, stdout, stderr) => {
      if (err) {
        // node couldn't execute the command
        res.send("ERROR from Terraform: " + stderr);
      }
      // the *entire* stdout and stderr (buffered)
      console.log(`stdout: ${stdout}`);
      console.log(`stderr: ${stderr}`);
      res.send("PROCESSED");
    });
  } else {
    res.send("ERROR");
  }
});

// Downsize recorders for domain
app.get("/remove-recorders", (req, res) => {
  let id = req.query.id;
  let password = req.query.password;

  console.log("Pass " + password);
  console.log("ID " + id);

  let random = uniqid();
  if (password == PASS) {
    var command = `cd digitalocean-jibri;./remove.sh ${id}`;

    exec(command, (err, stdout, stderr) => {
      if (err) {
        // node couldn't execute the command
        res.send("ERROR from Terraform: " + stderr);
      }
      // the *entire* stdout and stderr (buffered)
      console.log(`stdout: ${stdout}`);
      console.log(`stderr: ${stderr}`);
      res.send("REMOVED "+id);
    });
  } else {
    res.send("ERROR");
  }
});
