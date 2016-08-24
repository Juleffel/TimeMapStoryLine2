module XmppHelper
  require 'xmpp4r'
  require 'xmpp4r/vcard/helper/vcard'
  include Jabber

  def update_vcard(jid, password, attributes)
    # Do the client stuff...
    clJID = JID.new(jid)
    cl = Client.new(clJID)
    cl.connect
    cl.auth(password)

    # The Vcard helper
    vcard_helper = Vcard::Helper.new(cl)
    begin
        vcard = vcard_helper.get()
        p "Vcard already existing."
    rescue
        vcard = Vcard::IqVcard.new
        p "No vcard found, use a new one."
    end

    changed = false
    attributes.each do |attribute, value|
      if vcard[attribute] != value
        changed = true
        p attribute.to_s+" has changed."
        p "From ",vcard[attribute]," to ",value
        vcard[attribute] = value
      end
    end

    if changed
        p "Vcard has changed, setting it..."
        if e = vcard_helper.set(vcard)
          p "Vcard successfully updated."
        else
          p "Error updating vcard:", e
        end
    end
    cl.close
  end

    def prebind(user)
      bosh_ok = true
      if user
          bosh_session = Bosh4r::Session.new(user.jid, user.xmpp_password, {bosh_url: 'https://conversejs.org/http-bind/'})
          p "Bosh session created:", bosh_session
          register = false
          begin
              bosh_session.connect
          rescue Exception => e
              p 'Rescue: Connect failed from the following reason:', e
              register = true
          end
          if register
              p 'Try register'
              begin
                  answer = bosh_session.register
                  status = answer.elements["/body/iq"].attributes["type"]
                  if status == "result"
                      p "Register Succeded."
                      bosh_session.connect
                  else
                      p "Register Failed, status:", status
                      p answer.to_s
                      bosh_ok = false
                  end
              rescue Exception => e
                  p 'Rescue: Register failed. Aborting.'
                  p e
                  p bosh_session
                  bosh_ok = false
              end
          end
      else
          bosh_ok = false
      end
      if bosh_ok
          user.update_attributes(xmpp_valid: true)
          user.update_vcard
          return {error: false, jid: bosh_session.jabber_id, sid: bosh_session.sid, rid: bosh_session.rid}
      else
          return {error: true}
      end
    end
end
