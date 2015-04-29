window.apiRoutes = {
  "basePath": "/api",
  "routes": {

    "settingById":       "/settings/:id",
    "settingsByHid":     "/settings/:hid",
    "cloudsById":        "/clouds/:id",

    "alerts":            "/alerts",
    "alertsById":        "/alerts/:id",

    "orders":            "/orders/:id",
    "orderItems":        "/order_items/:id",

    "projectGroups":     "/projects/:projectId/groups",
    "projectGroupById":  "/projects/:projectId/groups/:groupId",
    "projectsById":      "/projects/:id",
    "projectQuestions":  "/project_questions/:id",
    "servicesById":      "/services/:id",

    "productsById":      "/products/:id",
    "productTypesById":  "/product_types/:id",

    "signIn":            "/staff/sign_in",
    "signOut":           "/staff/sign_out",
    "ssoInit":           "/saml/init",

    "staffOrders":       "/staff/:staff_id/orders/:id",
    "staffById":         "/staff/:id",
    "staffSearch":       "/staff?query=",
    "currentMember":     "/staff/current_member",

    "services":           "/services",
    "serviceAll":         "/services/all_count",
    "serviceProject":     "/services/project_count",

    "groups":            "/groups",
    "groupsById":        "/groups/:id"
  }
};
