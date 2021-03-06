class XmppController < ApplicationController
    require 'xmpp4r'
    require 'xmpp4r/vcard/helper/vcard'
    require 'rexml/xpath'
    include Jabber

    def prebind
      render :json => ApplicationController.helpers.prebind(current_user)
    end










    def prebind_test
        bosh_ok = false
        bosh_session = Bosh4r::Session.new("testtest@jabberzac.org", "testtest", {bosh_url: 'https://conversejs.org/http-bind/'})
        begin
            p bosh_session.connect
            bosh_ok = true
        rescue
            p 'Error in connection'
            p bosh_session
        end
        p bosh_ok
        if bosh_ok
            render :json => {jid: bosh_session.jabber_id, sid: bosh_session.sid, rid: bosh_session.rid}
        else
            render :json => {error: true}
        end
    end

    def prebind_test_contacts
        bosh_ok = false
        jid = "testtestcontacts"
        if params[:num]
            num = params[:num].to_s
            jid += params[:num]
        end
        jid += "@jabberzac.org"
        ApplicationController.helpers.update_vcard(
          jid, "testtest",
          {
            'FN' => "Test Contacts vCard "+num,
            'NICKNAME' => "Test Contacts vCard Nick "+num,
          })
        bosh_session = Bosh4r::Session.new(jid, "testtest", {bosh_url: 'https://conversejs.org/http-bind/'})
        begin
            p bosh_session.connect
            bosh_ok = true
        rescue
            p 'Error in connection'
            p bosh_session
            register = true
        end
        if register
            p 'register'
            begin
                p bosh_session.register
                p bosh_session.connect
                bosh_ok = true
            rescue
                p 'register rescue'
                bosh_ok = false
            end
        end
        p bosh_ok
        if bosh_ok
            render :json => {jid: bosh_session.jabber_id, sid: bosh_session.sid, rid: bosh_session.rid}
        else
            render :json => {error: true}
        end
    end
end
