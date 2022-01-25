# SPDX-License-Identifier: AGPL-3.0-or-later

JETTY_VERSION=9.4.44.v20210927
JETTY_TARBALL=jetty-distribution-$(JETTY_VERSION).tar.gz
JETTY_URL=https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/$(JETTY_VERSION)/$(JETTY_TARBALL)
JETTY_DIR=tmp/jetty-distribution-$(JETTY_VERSION)

all: jetty-bin
	echo -n

tmp/$(JETTY_TARBALL):
	mkdir -p tmp
	(cd tmp && wget "$(JETTY_URL)")

jetty-bin: tmp/$(JETTY_TARBALL)
	(cd tmp && tar -xzf "$(JETTY_TARBALL)")

include build.mk

install: all
	$(call mk_install_dir, jetty_base/webapps/zimbra)
	$(call mk_install_dir, jetty_base/etc)
	$(call mk_install_dir, jetty_base/modules)
	$(call mk_install_dir, jetty_base/modules/npn)
	$(call mk_install_dir, jetty_base/start.d)

	cp conf/robots.txt                         $(INSTALL_DIR)/jetty_base/webapps/zimbra/robots.txt
	cp conf/jetty/jettyrc                      $(INSTALL_DIR)/jetty_base/etc/
	cp conf/jetty/zimbra.policy.example        $(INSTALL_DIR)/jetty_base/etc/
	cp conf/jetty/jetty-logging.properties     $(INSTALL_DIR)/jetty_base/etc/
	cp conf/jetty/jetty.xml.production         $(INSTALL_DIR)/jetty_base/etc/jetty.xml.in
	cp conf/jetty/webdefault.xml.production    $(INSTALL_DIR)/jetty_base/etc/webdefault.xml
	cp conf/jetty/jetty-setuid.xml             $(INSTALL_DIR)/jetty_base/etc/jetty-setuid.xml
	cp conf/jetty/spnego/etc/spnego.properties $(INSTALL_DIR)/jetty_base/etc/spnego.properties.in
	cp conf/jetty/spnego/etc/spnego.conf       $(INSTALL_DIR)/jetty_base/etc/spnego.conf.in
	cp conf/jetty/spnego/etc/krb5.ini          $(INSTALL_DIR)/jetty_base/etc/krb5.ini.in
	cp conf/jetty/modules/*.mod                $(INSTALL_DIR)/jetty_base/modules
	cp conf/jetty/modules/*.mod.in             $(INSTALL_DIR)/jetty_base/modules
	cp conf/jetty/start.d/*.ini.in             $(INSTALL_DIR)/jetty_base/start.d
	cp conf/jetty/modules/npn/*.mod            $(INSTALL_DIR)/jetty_base/modules/npn

	(cd $(INSTAlL_DIR) && ln -s jetty_base mailboxd)

	$(call mk_install_dir, common)
	cp -R $(JETTY_DIR) $(INSTALL_DIR)/common/jetty_home
	rm -Rf $(INSTALL_DIR)/common/jetty_home/etc/jetty.xml \
	       $(INSTALL_DIR)/common/jetty_home/logs \
	       $(INSTALL_DIR)/common/jetty_home/resources \
	       $(INSTALL_DIR)/common/jetty_home/webapps \
	       $(INSTALL_DIR)/common/jetty_home/demo-base

clean:
	rm -Rf tmp
