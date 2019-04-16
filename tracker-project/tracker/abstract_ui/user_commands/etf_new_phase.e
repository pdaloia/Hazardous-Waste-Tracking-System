note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_NEW_PHASE
inherit
	ETF_NEW_PHASE_INTERFACE
		redefine new_phase end
create
	make
feature -- command
	new_phase(pid: STRING ; phase_name: STRING ; capacity: INTEGER_64 ; expected_materials: ARRAY[INTEGER_64])
		require else
			new_phase_precond(pid, phase_name, capacity, expected_materials)
    	local
    		new_phase_op : NEW_PHASE
    		message_op: MESSAGE
    	do
			-- perform some update on the model state
			model.default_update

    		if model.tracker.tracker_in_use and model.tracker.no_of_containers>=1 then
    			create message_op.make (model.err_e1)
    			message_op.execute
    			model.history.extend_history (message_op)
    			model.history.extend_state (model.current_i)
    			model.history.extend_message (model.err_e1)
    		elseif not pid.at (1).is_alpha_numeric or not phase_name.at (1).is_alpha_numeric  then
       			create message_op.make (model.err_e5)
    			message_op.execute
    			model.history.extend_history (message_op)
    			model.history.extend_state (model.current_i)
    			model.history.extend_message (model.err_e5)
       		elseif model.tracker.phases.has (pid) then
       			create message_op.make (model.err_e6)
    			message_op.execute
    			model.history.extend_history (message_op)
    			model.history.extend_state (model.current_i)
    			model.history.extend_message (model.err_e6)
       		elseif capacity <= 0 then
       			create message_op.make (model.err_e7)
    			message_op.execute
    			model.history.extend_history (message_op)
    			model.history.extend_state (model.current_i)
    			model.history.extend_message (model.err_e7)
       		elseif expected_materials.is_empty then
       			create message_op.make (model.err_e8)
    			message_op.execute
    			model.history.extend_history (message_op)
    			model.history.extend_state (model.current_i)
    			model.history.extend_message (model.err_e8)
			else
				create new_phase_op.make
				new_phase_op.set_phase(pid, phase_name, capacity, expected_materials)
				model.history.extend_history (new_phase_op)
				model.history.extend_state (model.current_i)
				model.history.extend_message (model.err_success)
				new_phase_op.execute
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
