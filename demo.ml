let x = 2

let f x y = if x then x + 1 else y

let g f x = x + f 1

let apply f x = f x

let flip f x y = f y x

let rec hungry x = hungry

let rec print_more str =
  print_endline str;
  print_more

let _ = print_more "hello" "world" "how" "are" "you"
