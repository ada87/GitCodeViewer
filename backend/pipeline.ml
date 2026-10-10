(* pipeline.ml — OCaml demo for syntax highlighting *)

open Printf

(* Domain types *)

type role =
  | Admin
  | Editor
  | Viewer

type user = {
  id : string;
  name : string;
  email : string;
  role : role;
  created_at : float;
}

type 'a api_response =
  | Ok of 'a
  | Error of string

exception Unknown_user of string

(* Helpers *)

let role_to_string = function
  | Admin -> "admin"
  | Editor -> "editor"
  | Viewer -> "viewer"

let make_user id name email role =
  { id; name; email; role; created_at = Unix.gettimeofday () }

let is_privileged user =
  match user.role with
  | Admin | Editor -> true
  | Viewer -> false

(* A tiny in-memory repository *)

module User_repo = struct
  let store : (string, user) Hashtbl.t = Hashtbl.create 16

  let save user =
    Hashtbl.replace store user.id user;
    Ok user

  let find id =
    match Hashtbl.find_opt store id with
    | Some user -> Ok user
    | None -> Error (sprintf "user %s not found" id)

  let find_exn id =
    match find id with
    | Ok user -> user
    | Error _ -> raise (Unknown_user id)

  let all () =
    Hashtbl.fold (fun _ user acc -> user :: acc) store []
    |> List.sort (fun a b -> compare a.name b.name)
end

(* Pipeline: fetch -> validate -> render *)

let validate user =
  if String.length user.name = 0 then Error "empty name"
  else if not (String.contains user.email '@') then Error "invalid email"
  else Ok user

let render_user user =
  printf "[%s] %s <%s> (%s)\n"
    user.id user.name user.email (role_to_string user.role)

let process ids =
  ids
  |> List.filter_map (fun id ->
       match User_repo.find id with
       | Ok user -> (match validate user with
           | Ok valid -> Some valid
           | Error msg -> eprintf "skip %s: %s\n" id msg; None)
       | Error _ -> None)
  |> List.iter render_user

(* Entry point *)

let () =
  let seed =
    [ make_user "u1" "Ada" "ada@example.com" Admin;
      make_user "u2" "Grace" "grace@example.com" Editor;
      make_user "u3" "Alan" "alan@example.com" Viewer ]
  in
  List.iter (fun u -> ignore (User_repo.save u)) seed;
  process [ "u1"; "u2"; "u3"; "u404" ]
