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
end
