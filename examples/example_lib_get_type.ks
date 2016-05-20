// This file is distributed under the terms of the MIT license, (c) the KSLib team

run lib_get_type.

function print_many_messages {
  parameter messages.

  if get_type(messages) = "STRING" {
    print messages.
  } else {
    for message in messages {
      print message.
    }
  }
}

print_many_messages("Howdy").

print_many_messages(list(
  "Isn't it cool how we can now",
  "have a single function run on",
  "both a list and a single string?"
)).
