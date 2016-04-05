var $body = $('body')
var signedin = $body.data('signedin');
var int_set_status = undefined;
console.log(signedin);
if (signedin) {
	var jid = $body.data('jid');
	var pseudo = $body.data('pseudo');
	console.log("You are:", jid, pseudo);
	var users = $body.data('users');
	require(['converse'], function (converse) {
	    converse.listen.on('ready', function(ev) {

	    	setTimeout(function() {
	    		console.log('Opening TMSL chatbox.')
    			console.log(converse.rooms.open('tmsl@conference-tmsl.no-ip.info', pseudo));
	    	},500);
	    	setTimeout(function() {
	    		var contacts_set = new Set()
	    		var contacts_hash = {}
	    		var contacts = converse.contacts.get()
	    		console.log("Contacts:")
	    		console.log(contacts);
	    		for (var i in contacts) {
	    			var contact = contacts[i];
	    			console.log(contact.jid, contact.fullname);
	    			if (contact.jid in users) {
	    				contacts_set.add(contact.jid)
	    				contacts_hash[contact.jid] = contact
	    			} else {
	    				// TODO remove contact
							// Euuuuh... Nope.
	    			}
	    		}
	    		console.log("Users:")
	    		for (var user_jid in users) {
	    			var user_pseudo = users[user_jid];
	    			console.log(user_jid, user_pseudo);
	    			if (!(contacts_set.has(user_jid))) {
	    				console.log("Adding...", user_jid, user_pseudo)
	    				console.log(user_jid, contacts_set, contacts_set.has(user_jid))
	    				converse.contacts.add(user_jid, user_pseudo);
	    			}
	    		}
	    	}, 500);
	    	/*int_set_status = setInterval(function() {
					status = converse.user.status.get();
					status_message = converse.user.status.message.get();
					console.log(status, status_message);
					console.log("Status Set.",converse.user.status.set(status, status_message));
	    	}, 2000);*/
				/*int_set_status = setInterval(function() {
					status = converse.user.status.get();
					status_message = converse.user.status.message.get();
					console.log(status, status_message);
					var new_status;
					if (status == "online") {
						new_status = "dnd";
					} else {
						new_status = "online"
					}
					console.log("Temporary Status Set.",new_status,converse.user.status.set(new_status));
					setTimeout(function() {
						if (status_message !== undefined) {
							console.log("Old Status Set.",status,status_message,converse.user.status.set(status, status_message));
						} else {
							console.log("Old Status Set.",status,converse.user.status.set(status));
						}
					}, 2000);

	    	}, 5000);*/
	    });
	    converse.initialize({
	        bosh_service_url: 'https://conversejs.org/http-bind/', // Please use this connection manager only for testing purposes
	        keepalive: true,
	        message_carbons: true,
	        roster_groups: true,
	        show_controlbox_by_default: true,
	        xhr_user_search: false,
	        jid: jid,
	        prebind_url: '/xmpp_prebind',
	        authentication: 'prebind', // authentification or prebind to let the server do it
	        //i18n: locales.en, // Refer to ./locale/locales.js to see which locales are supported
	        // restrain usage
	        allow_contact_requests: true,
	        allow_contact_removal: true,
	        allow_registration: false,
	        auto_list_rooms: true,
	        auto_reconnect: true,
	        auto_subscribe: true,
	        hide_offline_users: false,
					message_archiving: true,
					use_vcards: true,
					//debug: true,
	    });
	    //converse.contacts.add('buddy@example.com‘, ‘Buddy’)
	    //console.log(converse.rooms.get('tmsl@conference.conversejs.org'));


	});
}
