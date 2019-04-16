note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_NEW_CONTAINER
inherit
	ETF_NEW_CONTAINER_INTERFACE
		redefine new_container end
create
	make
feature -- command
	new_container(cid: STRING ; c: TUPLE[material: INTEGER_64; radioactivity: VALUE] ; pid: STRING)
		require else
			new_container_precond(cid, c, pid)
		local
    		new_container_op : NEW_CONTAINER
    		message_op : MESSAGE
    		default_val : VALUE
    		a_phase : PHASE
    	do
			-- perform some update on the model state
			model.default_update
			create default_val.default_create
			if not cid.at (1).is_alpha_numeric  then
	   			create message_op.make (model.err_e5)
    			message_op.execute
    			model.history.extend_history (message_op)
    			model.history.extend_state (model.current_i)
    			model.history.extend_message (model.err_e5)
    
    		elseif  model.tracker.has_container (cid) then
	   			create message_op.make (model.err_e10)
    			message_op.execute
     			model.history.extend_history (message_op)
     			model.history.extend_state (model.current_i)
     			model.history.extend_message (model.err_e10)
	    	elseif not model.tracker.phases.has (pid) then
	    		create message_op.make (model.err_e9)
	   			message_op.execute
	   			model.history.extend_history (message_op)
	   			model.history.extend_state (model.current_i)
	   			model.history.extend_message (model.err_e9)
    		elseif c.radioactivity.is_less (default_val) then
    			create message_op.make (model.err_e18)
	    		message_op.execute
	    		model.history.extend_history (message_op)
	    		model.history.extend_state (model.current_i)
	    		model.history.extend_message (model.err_e18)
	   		else
	   			a_phase := model.tracker.phases.item (pid)
				check attached a_phase as p then
		    		if p.container_count = p.capacity then
		    			create message_op.make (model.err_e11)
			    		message_op.execute
			    		model.history.extend_history (message_op)
			    		model.history.extend_state (model.current_i)
			    		model.history.extend_message (model.err_e11)
			    	elseif  c.radioactivity > model.tracker.max_container_radiation then
			    		create message_op.make (model.err_e14)
			    		message_op.execute
			    		model.history.extend_history (message_op)
			    		model.history.extend_state (model.current_i)
			    		model.history.extend_message (model.err_e14)
			   		elseif (p.phase_radiation + c.radioactivity) > model.tracker.max_phase_radiation then
			   			create message_op.make (model.err_e12)
			   			message_op.execute
			   			model.history.extend_history (message_op)
			   			model.history.extend_state (model.current_i)
			   			model.history.extend_message (model.err_e12)
			    	elseif not p.expected_materials_no.has (c.material) then
			   			create message_op.make (model.err_e13)
			   			message_op.execute
			   			model.history.extend_history (message_op)
			   			model.history.extend_state (model.current_i)
			   			model.history.extend_message (model.err_e13)
			   		else
						create new_container_op.make
						new_container_op.set_container(cid, c, pid)
						model.history.extend_history (new_container_op)
						model.history.extend_state (model.current_i)
						model.history.extend_message (model.err_success)
						new_container_op.execute
					end
				end
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
