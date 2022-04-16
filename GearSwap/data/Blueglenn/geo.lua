function get_sets()
	-- Load and initialize the include file. 
	mote_include_version = 2
	include('Mote-Include.lua')
	include('organizer-lib')
end

function init_gear_sets()
	-- this is the order.  the order is arbitrary, but you should try to keep it consistent
    -- main
    -- sub
    -- range
    -- ammo
    -- head
    -- body
    -- hands
    -- legs
    -- feet
    -- neck 
    -- ear1
    -- ear2
    -- ring1
    -- ring2
    -- back
    -- waist

	sets.idle = {	main = "Sucellus",
					sub  = "Genmei Shield",
					range= "Dunna",
					head = "Azimuth hood +1",
					body = "Geomancy Tunic +3",
					hands= "Geomancy Mitaines +3",
					legs = "Psycloth Lappas",
					feet = "Bagua Sandals +3",
					neck = "Loricate Torque +1",
					ear1 = "Handler's Earring",
					ear2 = "Handler's Earring +1",
					ring1= "Dark Ring",
					ring2= "Defending Ring",
					back = "Nantosuelta's cape",
					waist= "Isa Belt" }
					
	sets.precast.FC = { }
	
	sets.precast.FC.Cure = { head = "Jhakri coronal +2"}
	
	sets.precast.FC.Curaga = sets.precast.FC.Cure
	
	sets.midcast.Cure = { main = "Gada" }
	
end