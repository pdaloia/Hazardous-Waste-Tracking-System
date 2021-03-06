note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_REMOVE_CONTAINER
inherit
	ETF_REMOVE_CONTAINER_INTERFACE
		redefine remove_container end
create
	make
feature -- command
	remove_container(cid: STRING)
		require else
			remove_container_precond(cid)
		local
			remove_container_op : REMOVE_CONTAINER
    		message_op : MESSAGE
    	do
			-- perform some update on the model state
			model.default_update

			if not model.tracker.has_container (cid)  then
				create message_op.make (model.err_e15)
				message_op.execute
				model.history.extend_history (message_op)
				model.history.extend_state (model.current_i)
				model.history.extend_message (model.err_e15)
			else
				create remove_container_op.make
				remove_container_op.set_remove (cid)
				model.history.extend_history (remove_container_op)
				model.history.extend_state (model.current_i)
				model.history.extend_message (model.err_success)
				remove_container_op.execute
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
