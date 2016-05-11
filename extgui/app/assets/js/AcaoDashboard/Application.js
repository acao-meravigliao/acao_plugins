/*
 * Copyright (C) 2014-2014, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('AcaoDashboard.Application', {
  extend: 'Extgui.app.Base',
  requires: [
    'AcaoDashboard.LoginDialog',
  ],

  name: 'AcaoDashboardApp',
  dashboardCard: 'AcaoDashboard.DashboardCard',
  mainControllerClass: 'AcaoDashboard.MainController',
  loginDialogClass: 'AcaoDashboard.LoginDialog',
  requiredCapability: 'simple_interface',
});
