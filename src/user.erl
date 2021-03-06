%%
%%Copyright (c) <2011>, Kuleshov Alexander <kuleshovmail@gmail.com>
%%All rights reserved.
%%
-module(user).

-include("define.hrl").

%%
%% General user data
%%
-export([get_user/3]).
-export([get_user_name/3]).
-export([get_user_bio/3]).
-export([get_user_following/3]).
-export([get_user_email/3]).
-export([get_user_location/3]).
-export([get_user_public_gist_count/3]).
-export([get_user_public_repos_count/3]).

%%
%% User followers
%%
-export([follow_user/3]).
-export([unfollow_user/3]).

%%
%% User email
%%
-export([user_delete_email_address/3]).
-export([user_add_email_address/3]).

%%==============================================
%%             Github Users
%%==============================================

%%
%% @spec get_user(User, UserName, Password) -> Content
%% @doc - Get USER contetn
%% @type - User = String()
%% @type - UserName = Strng()
%% @type - Password = String()
%% @type - Content = [String()]
%%
get_user(User, UserName, Password) ->
	github:init(),
    ibrowse:send_req(?USERS ++ User, [], get, [],
					  [{basic_auth, {UserName, Password}}, 
					   {ssl_options, [{verify, 0}, {depth, 3}]}]).

%%
%% @spec get_user_email(User, UserName, Password) -> Email
%% @doc -  Get user email
%% @type - User = String()
%% @type - UserName = Strng()
%% @type - Password = String()
%% @type - Email = [String()]
%%
get_user_email(User, UserName, Password) ->
	GetUser = get_user(User, UserName, Password),
	case GetUser of
		{ok, "200", _, Content} ->
			FlatContent = lists:flatten(Content),
			Rstr = string:rstr(FlatContent, "email"),
			SubString = string:tokens(string:sub_string(Content, Rstr), ","),
			Tokens = string:tokens(lists:nth(1, SubString), ":"),
			lists:nth(1, utils:clean_quotes(lists:nth(2,Tokens)));
		_ ->
			error_logger:error_msg("User " ++ UserName ++  " " ++ 
									   "obtaining error")
		end.

%%
%% @spec get_user_public_repos_count(User, UserName, Password) -> Count
%% @doc -  Get user public repos count
%% @type - User = String()
%% @type - UserName = Strng()
%% @type - Password = String()
%% @type - Count = Int()
%%
get_user_public_repos_count(User, UserName, Password) ->
	GetUser = get_user(User, UserName, Password),
	case GetUser of
		{ok, "200", _, Content} ->
			FlatContent = lists:flatten(Content),
			Rstr = string:rstr(FlatContent, "public_repos"),
			SubString = string:tokens(string:sub_string(Content, Rstr), ","),
			Tokens = string:tokens(lists:nth(1, SubString), ":"),
			list_to_integer(lists:nth(1, utils:clean_quotes(lists:nth(2,Tokens))));
		_ ->
			error_logger:error_msg("User " ++ UserName ++  " " ++ 
									   "obtaining error")
		end.

%%
%% @spec get_user_name(User, UserName, Password) -> Name
%% @doc -  Get user Name
%% @type - User = String()
%% @type - UserName = Strng()
%% @type - Password = String()
%% @type - Name = [String()]
%%
get_user_name(User, UserName, Password) ->
	GetUser = get_user(User, UserName, Password),
	case GetUser of
		{ok, "200", _, Content} ->
			FlatContent = lists:flatten(Content),
			Rstr = string:rstr(FlatContent, "name"),
			SubString = string:tokens(string:sub_string(Content, Rstr), ","),
			Tokens = string:tokens(lists:nth(1, SubString), ":"),
			utils:clean_quotes(lists:nth(2,Tokens));
		_ ->
			error_logger:error_msg("User " ++ UserName ++  " " ++ 
									   "obtaining error")
		end.

%%
%% @spec get_user_name(User, UserName, Password) -> Following
%% @doc -  Get user following count
%% @type - User = String()
%% @type - UserName = Strng()
%% @type - Password = String()
%% @type - Following = int()
%%
get_user_following(User, UserName, Password) ->
	GetUser = get_user(User, UserName, Password),
	case GetUser of
		{ok, "200", _, Content} ->
			FlatContent = lists:flatten(Content),
			Rstr = string:rstr(FlatContent, "following"),
			SubString = string:tokens(string:sub_string(Content, Rstr), ","),
			Tokens = string:tokens(lists:nth(1, SubString), ":"),
			list_to_integer(lists:nth(1,utils:clean_quotes(lists:nth(2,Tokens))));
		_ ->
			error_logger:error_msg("User " ++ UserName ++  " " ++ 
									   "obtaining error")
	end.

%%
%% @spec get_user_location(User, UserName, Password) -> Location
%% @doc -  Get user location
%% @type - User = String()
%% @type - UserName = Strng()
%% @type - Password = String()
%% @type - Location = [String()]
%%
get_user_location(User, UserName, Password) ->
	GetUser = get_user(User, UserName, Password),
	case GetUser of
		{ok, "200", _, Content} ->
			FlatContent = lists:flatten(Content),
			Rstr = string:rstr(FlatContent, "location"),
			SubString = string:tokens(string:sub_string(Content, Rstr), ","),
			Tokens = string:tokens(lists:nth(1, SubString), ":"),
			utils:clean_quotes(lists:nth(2,Tokens));
		_ ->
			error_logger:error_msg("User " ++ UserName ++  " " ++ 
									   "obtaining error")
		end.

%%
%% @spec get_user_bio(User, UserName, Password) -> Bio
%% @doc -  Get user bio
%% @type - User = String()
%% @type - UserName = Strng()
%% @type - Password = String()
%% @type - Bio = [String()]
%%
get_user_bio(User, UserName, Password) ->
	GetUser = get_user(User, UserName, Password),
	case GetUser of
		{ok, "200", _, Content} ->
			FlatContent = lists:flatten(Content),
			Rstr = string:rstr(FlatContent, "bio"),
			SubString = string:tokens(string:sub_string(Content, Rstr), ","),
			Tokens = string:tokens(lists:nth(1, SubString), ":"),
			utils:clean_quotes(lists:nth(2,Tokens));
		_ ->
			error_logger:error_msg("User " ++ UserName ++  " " ++ 
									   "obtaining error")
		end.

%%
%% @spec get_user_public_gist_count(User, UserName, Password) -> Count
%% @doc -  Get user public gist count
%% @type - User = String()
%% @type - UserName = Strng()
%% @type - Password = String()
%% @type - Count = int()
%%
get_user_public_gist_count(User, UserName, Password) ->
	GetUser = get_user(User, UserName, Password),
	case GetUser of
		{ok, "200", _, Content} ->
			FlatContent = lists:flatten(Content),
			Rstr = string:rstr(FlatContent, "public_gists"),
			SubString = string:tokens(string:sub_string(Content, Rstr), ","),
			Tokens = string:tokens(lists:nth(1, SubString), ":"),
			list_to_integer(lists:nth(1,utils:clean_quotes(lists:nth(2,Tokens))));
		_ ->
			error_logger:error_msg("User " ++ UserName ++  " " ++ 
									   "obtaining error")
	end.

%%==============================================
%%             Github Users email
%%==============================================

%%
%% @spec user_add_email_address(Adress, UserName, Password) -> ok
%% @doc -  Add user email
%% @type - Address = String()
%% @type - UserName = Strng()
%% @type - Password = String()
%% @type - ok = atom()
%%
user_add_email_address(Address, UserName, Password) ->
	MakeAdress = messages:make_add_email_message(Address),
	ibrowse:send_req(?USERS ++ "emails", [], post, MakeAdress,
				  [{basic_auth, {UserName, Password}},{stream_to, self()}, 
	    		   {ssl_options, [{verify,verify_none}, {depth, 3}]}]),
	ok.

%%
%% @spec user_delete_email_address(Adress, UserName, Password) -> ok
%% @doc -  Delete user Email
%% @type - Address = String()
%% @type - UserName = Strng()
%% @type - Password = String()
%% @type - ok = atom()
%%
user_delete_email_address(Address, UserName, Password) ->
	MakeAdress = messages:make_add_email_message(Address),
	ibrowse:send_req(?USERS ++ "emails", [], delete, MakeAdress,
				  [{basic_auth, {UserName, Password}},{stream_to, self()}, 
	    		   {ssl_options, [{verify,verify_none}, {depth, 3}]}]),
	ok.

%%==============================================
%%             Github User followers
%%==============================================

%%
%% @spec follow_user(User, UserName, Password) -> ok
%% @doc -  Follow user
%% @type - User = String()
%% @type - UserName = Strng()
%% @type - Password = String()
%% @type - ok = atom()
%%
follow_user(User, UserName, Password) ->
	ibrowse:send_req(?USERS ++ "/following/" ++ User, [], put, [],
				  [{basic_auth, {UserName, Password}},{stream_to, self()}, 
	    		   {ssl_options, [{verify,verify_none}, {depth, 3}]}]),
	ok.

%%
%% @spec unfollow_user(User, UserName, Password) -> ok
%% @doc -  Unfollow user
%% @type - User = String()
%% @type - UserName = Strng()
%% @type - Password = String()
%% @type - ok = atom()
%%
unfollow_user(User, UserName, Password) ->
	ibrowse:send_req(?USERS ++ "/following/" ++ User, [], delete, [],
				  [{basic_auth, {UserName, Password}},{stream_to, self()}, 
	    		   {ssl_options, [{verify,verify_none}, {depth, 3}]}]),
	ok.