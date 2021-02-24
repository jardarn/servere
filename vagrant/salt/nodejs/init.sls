nodejs:
  pkg:
    - installed
npm:
  pkg:
    - installed
coffeescript:
  pkg:
    - installed
  require:
    - pkg: nodejs
python-mysqldb:
  pkg:
    - installed

/usr/local/bin/node:
  file.symlink:
    - target: /usr/bin/nodejs

less:
  cmd.run:
    - name: npm install -g less

sass:
  cmd.run:
    - name: npm install -g sass