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
        p "Vcard already existing:"
        p vcard.to_s

    rescue
        vcard = Vcard::IqVcard.new
        p "No vcard found, use a new one."
    end

    changed = false
    p attributes
    attributes.each do |attribute, value|
        p attribute, vcard[attribute], value
        changed |= vcard[attribute] != value
        vcard[attribute] = value
    end

    if changed
        p "Setting vcard..."
        p vcard.to_s
        p vcard_helper.set(vcard)
        p "Vcard setted correctly."
    end
    cl.close
  end
end
