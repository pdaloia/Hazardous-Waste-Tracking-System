note
	description: "History operations for undo/redo design pattern"
	author: "JSO"
	date: "$Date$"
	revision: "$Revision$"

class
	HISTORY

create
	make

feature{ETF_MODEL}
	make
		do
			create {ARRAYED_LIST[OPERATION]}history.make (10)
			create {ARRAYED_LIST[INTEGER]}state.make (10)
			create {ARRAYED_LIST[STRING]}message.make (10)
		end

feature -- history
	history: LIST[OPERATION]
		-- a history list of user invoked operations

	state: LIST[INTEGER]
		-- a history list of user invoked operations

	message: LIST[STRING]
		-- a history list of user invoked operations

	extend_history(a_op: OPERATION)
			-- remove all operations to the right of the current
			-- cursor in history, then extend with `a_op'
		do
			remove_right
			history.extend(a_op)
			history.finish
		ensure
			history[history.count] = a_op
		end

	extend_state(a_op: INTEGER)
			-- remove all operations to the right of the current
			-- cursor in history, then extend with `a_op'
		do
			remove_right_state
			state.extend(a_op)
			state.finish
		ensure
			state[state.count] = a_op
		end

	extend_message(a_op: STRING)
			-- remove all operations to the right of the current
			-- cursor in history, then extend with `a_op'
		do
			remove_right_message
			message.extend(a_op)
			message.finish
		ensure
			message[message.count] = a_op
		end

	remove_right
			--remove all elements
			-- to the right of the current cursor in history
		do
			if not history.islast and not history.after then
				from
					history.forth
				until
					history.after
				loop
					history.remove
				end
			end
		end

	remove_right_state
			--remove all elements
			-- to the right of the current cursor in history
		do
			if not state.islast and not state.after then
				from
					state.forth
				until
					state.after
				loop
					state.remove
				end
			end
		end

	remove_right_message
			--remove all elements
			-- to the right of the current cursor in history
		do
			if not message.islast and not message.after then
				from
					message.forth
				until
					message.after
				loop
					message.remove
				end
			end
		end

	remove
			--remove all elements
			-- to the right of the current cursor in history
		do
			  -- history.start
			if history.count > 0 then
			    from
					history.start
				until
					history.after
				loop
					history.remove
				end
			end
				history.start
		ensure
			history_reset:	history.count = 0
		end

	remove_state
			--remove all elements
			-- to the right of the current cursor in history
		do
			  -- history.start
			if state.count > 0 then
			    from
					state.start
				until
					state.after
				loop
					state.remove
				end
			end
				state.start
		ensure
			state_reset:	state.count = 0
		end

	remove_message
			--remove all elements
			-- to the right of the current cursor in history
		do
			  -- history.start
			if message.count > 0 then
			    from
					message.start
				until
					message.after
				loop
					message.remove
				end
			end
				message.start
		ensure
			message:	message.count = 0
		end

	item: OPERATION
			-- Cursor points to this user operation
		require
			on_item
		do
			Result := history.item
		end

	item_state: INTEGER
			-- Cursor points to this user operation
		require
			on_state_item
		do
			Result := state.item
		end

	item_message: STRING
			-- Cursor points to this user operation
		require
			on_message_item
		do
			Result := message.item
		end

	get_count: STRING
		do
			Result := history.count.out
		end

	get_state_count: STRING
		do
			Result := state.count.out
		end

	on_item: BOOLEAN
			-- cursor points to a valid operation
			-- cursor is not before or after
		do
			Result := history.valid_index (history.index)
		end

	on_state_item: BOOLEAN
			-- cursor points to a valid operation
			-- cursor is not before or after
		do
			Result := state.valid_index (state.index)
		end

	on_message_item: BOOLEAN
			-- cursor points to a valid operation
			-- cursor is not before or after
		do
			Result := message.valid_index (message.index)
		end

	forth
		do
			history.forth
		end

	back
		do
			history.back
		end

	not_last: BOOLEAN
		do
			Result := not history.is_empty and not history.islast
		end

	forth_state
		do
			state.forth
		end

	back_state
		do
			state.back
		end

	not_last_state: BOOLEAN
		do
			Result := not state.is_empty and not state.islast
		end

	forth_message
		do
			message.forth
		end

	back_message
		do
			message.back
		end

	not_last_message: BOOLEAN
		do
			Result := not message.is_empty and not message.islast
		end

end
