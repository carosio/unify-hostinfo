%%%-------------------------------------------------------------------
%%% @author Rick Payne <rickp@rossfell.co.uk>
%%% @copyright (C) 2014, Alistair Woodman, California USA <awoodman@netdef.org>
%%% @doc
%%%
%%% This file is part of AutoISIS.
%%%
%%% License:
%%% This code is licensed to you under the Apache License, Version 2.0
%%% (the "License"); you may not use this file except in compliance with
%%% the License. You may obtain a copy of the License at
%%% 
%%%   http://www.apache.org/licenses/LICENSE-2.0
%%% 
%%% Unless required by applicable law or agreed to in writing,
%%% software distributed under the License is distributed on an
%%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%%% KIND, either express or implied.  See the License for the
%%% specific language governing permissions and limitations
%%% under the License.
%%%
%%% @end
%%% Created : 6 Dec 2014 by Rick Payne <rickp@rossfell.co.uk>
%%%-------------------------------------------------------------------
-module(unify_hostinfo_feed).

-include_lib ("isis/include/isis_system.hrl").
-include_lib ("isis/include/isis_protocol.hrl").

-export([init/3, websocket_handle/3, websocket_info/3,
         websocket_init/3, websocket_terminate/3]).

-record(state, {
	 }).

init(_, _Req, _Opts) ->
    {upgrade, protocol, cowboy_websocket}.

websocket_init(_, Req, _Opts) ->
    {ok, Req, #state{}, 60000}.

websocket_handle({text,<<"start">>}, Req, State) ->
    unify_hostinfo:subscribe(),
    {ok, Req, State};

websocket_handle(Any, Req, State) ->
    error_logger:error_msg("buger ~p (~p)", [Any, State]),
    {ok, Req, State}.

websocket_terminate(_, _, _) ->
    ok.

websocket_info({host_update, Message}, Req, State) ->
    {reply, {text, Message}, Req, State}.
