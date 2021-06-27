#!/usr/bin/env python3

import sys
import json

def get_parameters(args):
  length = len(args)
  if length == 0:
    return None

  options = {
    '-i': '',
    '-h': '',
    '--minecraft': ''
  }
  for i, arg in enumerate(args):
    if not arg.startswith('-'):
      continue
    if i+1 == length:
      return None
    options[arg] = args[i+1]

  user, ip = options['-h'].split('@')
  return {
    'ip': ip,
    'user': user,
    'minecraft_version': options['--minecraft'],
    'identity_file': options['-i'],
  }

def main():
  args = sys.argv[1:]
  parameters = get_parameters(args)
  if parameters is None:
    return

  j = json.dumps(parameters)
  print(j)
  return

if __name__ == '__main__':
  main()
