export const hashRoute = subpath => `#/Puppet/${subpath}`;
export const route = subpath => hashRoute(subpath).substring(1);
export const activeTab = path => path.split('/')[2];
