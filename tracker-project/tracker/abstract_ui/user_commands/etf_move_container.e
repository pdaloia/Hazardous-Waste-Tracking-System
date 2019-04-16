note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MOVE_CONTAINER
inherit
	ETF_MOVE_CONTAINER_INTERFACE
		redefine move_container end
create
	make
feature -- command
	move_container(cid: STRING ; pid1: STRING ; pid2: STRING)
		require else
			move_container_precond(cid, pid1, pid2)
		local
			move_container_op : MOVE_CONTAINER
    		message_op : MESSAGE
    		a_phase1 : PHASE
    		a_phase2 : PHASE
    		a_container : PHASE_CONTAINER
    	do
			-- perform some update on the model state
			model.default_update
			a_phase1 := model.tracker.phases.item (pid1)
			a_phase2 := model.tracker.phases.item (pid2)

			if not model.tracker.has_container (cid)  then
			    create message_op.make (model.err_e15)
			    message_op.execute
			   	model.history.extend_history (message_op)
			   	model.history.extend_state (model.current_i)
			   	model.history.extend_message (model.err_e15)
			elseif pid1 ~ pid2  then
				create message_op.make (model.err_e16)
				message_op.execute
			   	model.history.extend_history (message_op)
			   	model.history.extend_state (model.current_i)
			   	model.history.extend_message (model.err_e16)
			elseif not model.tracker.phases.has (pid1) or not model.tracker.phases.has (pid2) then
				create message_op.make (model.err_e9)
				message_op.execute
			   	model.history.extend_history (message_op)
			   	model.history.extend_state (model.current_i)
			   	model.history.extend_message (model.err_e9)
			 else
			   	check attached a_phase1 as ap1 and attached a_phase2 as ap2 then
			   		a_container:= ap1.containers.item (cid)

						if not ap1.containers.has (cid)  then
							create message_op.make (model.err_e17)
							message_op.execute
						   	model.history.extend_history (message_op)
						   	model.history.extend_state (model.current_i)
						   	model.history.extend_message (model.err_e17)
						elseif ap2.container_count = ap2.capacity then
					    	create message_op.make (model.err_e11)
					    	message_op.execute
					    	model.history.extend_history (message_op)
					    	model.history.extend_state (model.current_i)
					    	model.history.extend_message (model.err_e11)
					    else
					    	check attached a_container as ac then
					   		if (ap2.phase_radiation + ac.radioactivity) > model.tracker.max_phase_radiation then
						    	create message_op.make (model.err_e12)
						    	message_op.execute
						    	model.history.extend_history (message_op)
						    	model.history.extend_state (model.current_i)
						    	model.history.extend_message (model.err_e12)
					    	elseif not ap2.expected_materials_no.has (ac.material) then
					    		create message_op.make (model.err_e13)
					    		message_op.execute
					    		model.history.extend_history (message_op)
					    		model.history.extend_state (model.current_i)
					    		model.history.extend_message (model.err_e13)
							else
								create move_container_op.make
								move_container_op.set_move (cid, pid1, pid2)
								model.history.extend_history (move_container_op)
								model.history.extend_state (model.current_i)
								model.history.extend_message (model.err_success)
								move_container_op.execute
							end
						end
					end
				end
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
