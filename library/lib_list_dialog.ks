// This file is distributed under the terms of the MIT license, (c) the KSLib team

@LAZYGLOBAL OFF.

run lib_menu.

function open_list_dialog {
  parameter
    title,
    option_list.

  local action_list is list("Next page", "Previous page").
  return _list_dialog(title, option_list, action_list, -1).
}

function open_cancelable_list_dialog {
  parameter
    title,
    option_list.

  local action_list is list("Next page", "Previous page", "Cancel").
  return _list_dialog(title, option_list, action_list, -2).
}


// this function is internal and should not be used outside lib_list_dialog
function _list_dialog {
  parameter
    title,
    option_list,
    action_list,
    internal_action_offset.

  local inaccessibe_lines is 11.
  local page_start is 0.
  local result is internal_action_offset.
  until result > internal_action_offset {
    local page_height is terminal:height - inaccessibe_lines - action_list:length.
    local new_start is 0.
    until new_start + page_height > page_start {  // workaround for kOS bug #897
      set new_start to new_start + page_height.
    }
    set page_start to new_start.
    local menu_list is action_list:copy.
    for option in option_list:sublist(page_start, page_height) {
      menu_list:add(option).
    }
    local title is title + " [Page: " + (page_start / page_height + 1) + " / " + (ceiling(option_list:length/page_height)) + "]".
    set result to open_menu_indexed(title, menu_list) - action_list:length.
    if result = internal_action_offset - 1 { // next
      set page_start to min(page_start + page_height, option_list:length - 1).
    } else if result = internal_action_offset { // previous
      set page_start to max(0, page_start - page_height).
    }
  }
  if result >= 0 {
    set result to page_start + result.
  }
  return result.
}
