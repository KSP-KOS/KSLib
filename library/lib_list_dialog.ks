// This file is distributed under the terms of the MIT license, (c) the KSLib team

@LAZYGLOBAL OFF.

run lib_menu.

// if someone finds a way to abstract it out please implement it

// public:

function open_list_dialog {
  parameter
    title,
    options_list.

  local actions is list("next page", "previous page").
  local result is -1.
  local page_start is 0.
  until result >= 0 {
    local page_height is terminal:height - 10 - actions_list:length.
    local new_start is 0.
    until new_start > page_start {
      set new_start to new_start + page_height.
    }
    set page_start to new_start - page_height.
    set result to _list_dialog__page(title, actions_list, options_list, page_start, page_height).
    if result = -2 { // next
      set page_start to page_start + page_height. // to-do sanitize
    } else if result = -1 { // previous
      set page_start to max(0, page_start - page_height).
    }
  }
  return result.
}

function open_cancelable_list_dialog {
  parameter
    title,
    options_list.

    local actions is list("next page", "previous page", "cancel").
    local result is -1.
    local page_start is 0.
    until result >= -1 {
      local page_height is terminal:height - 10 - actions_list:length.
      local new_start is 0.
      until new_start > page_start {
        set new_start to new_start + page_height.
      }
      set page_start to new_start - page_height.
      set result to _list_dialog__page(title, actions_list, options_list, page_start, page_height).
      if result = -3 { // next
        set page_start to page_start + page_height. // to-do sanitize
      } else if result = -2 { // previous
        set page_start to max(0, page_start - page_height).
      }
    }
    return result.
}

// private:
function _list_dialog__page {
  parameter
    title,
    actions_list,
    options_list,
    page_start,
    page_height.

  local menu_list is actions_list:copy.
  for option in options_list:sublist(page_start, page_height) {
    menu_list:add(option).
  }
  set title to title + " page " + (page_start / page_height + 1) + " of " + (ceil(options_list:length/page_height)).
  return open_menu_indexed(title, menu_list) - actions_list:length.
}
