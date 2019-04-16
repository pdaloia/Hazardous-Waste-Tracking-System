note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_NEW_TRACKER
inherit
	ETF_NEW_TRACKER_INTERFACE
		redefine new_tracker end
create
	make
feature -- command
	new_tracker(max_phase_radiation: VALUE ; max_container_radiation: VALUE)
		local
			new_tracker_op : NEW_TRACKER
			message_op : MESSAGE
			default_val : VALUE
    	do
    		-- perform some update on the model state
    		model.default_update
    		create default_val.default_create


    		if model.tracker.tracker_in_use and model.tracker.no_of_containers>=1 then
    			create message_op.make (model.err_e1)
    			message_op.execute
    			model.history.extend_history (message_op)
    			model.history.extend_state (model.current_i)
    			model.history.extend_message (model.err_e1)
    		elseif  max_phase_radiation.is_less (default_val)  then
				create message_op.make (model.err_e2)
    			message_op.execute
    			model.history.extend_history (message_op)
    			model.history.extend_state (model.current_i)
    			model.history.extend_message (model.err_e2)
		    elseif  max_container_radiation.is_less (default_val) then
				create message_op.make (model.err_e3)
    			message_op.execute
    			model.history.extend_history (message_op)
    			model.history.extend_state (model.current_i)
    			model.history.extend_message (model.err_e3)
			elseif max_container_radiation > max_phase_radiation  then
				create message_op.make (model.err_e4)
    			message_op.execute
    			model.history.extend_history (message_op)
    			model.history.extend_state (model.current_i)
    			model.history.extend_message (model.err_e4)
		    else
				create new_tracker_op.make
				new_tracker_op.set_radiation(max_phase_radiation,max_container_radiation)
				model.history.remove
			--	model.history.remove_message
				model.history.remove_state
				model.tracker.set_active_tracker_op (new_tracker_op)
				model.history.extend_state (model.current_i)
				model.history.extend_message (model.err_success)
				new_tracker_op.execute
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
