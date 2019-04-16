note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_REMOVE_PHASE
inherit
	ETF_REMOVE_PHASE_INTERFACE
		redefine remove_phase end
create
	make
feature -- command
	remove_phase(pid: STRING)
		require else
			remove_phase_precond(pid)
		local
			remove_phase_op : REMOVE_PHASE
    		message_op : MESSAGE
    	do
			-- perform some update on the model state
			model.default_update
			if model.tracker.tracker_in_use and model.tracker.no_of_containers>=1 then
    			create message_op.make (model.err_e1)
    			message_op.execute
    			model.history.extend_history (message_op)
    			model.history.extend_state (model.current_i)
    			model.history.extend_message (model.err_e1)
			elseif not model.tracker.phases.has (pid)  then
				create message_op.make (model.err_e9)
				message_op.execute
				model.history.extend_history (message_op)
				model.history.extend_state (model.current_i)
				model.history.extend_message (model.err_e9)
			else
				create remove_phase_op.make
				remove_phase_op.set_remove (pid)
				model.history.extend_history (remove_phase_op)
				model.history.extend_state (model.current_i)
				model.history.extend_message (model.err_success)
				remove_phase_op.execute
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
