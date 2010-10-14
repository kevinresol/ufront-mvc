package ufront.web.routing;

import ufront.web.error.PageNotFoundError;
import ufront.web.HttpApplication;
import ufront.web.IHttpHandler;
import ufront.web.IHttpModule;

/**
 * Gets an IHttpHandler from the routing and executes it in the HttpApplication context.
 * @author Andreas Soderlund
 */
class UrlRoutingModule implements IHttpModule
{
	public var routeCollection(default, null) : RouteCollection;
	var httpHandler : IHttpHandler;
	
	public function new(?routeCollection : RouteCollection)
	{
		this.routeCollection = (routeCollection != null) ? routeCollection : new RouteCollection();
	}
	
	public function init(application : HttpApplication) : Void
	{
		application.postResolveRequestCache.add(setHttpHandler);
		application.postMapRequestHandler.add(executeHttpHandler);
	}
	
	function setHttpHandler(application : HttpApplication)
	{
		var httpContext = application.httpContext;
		
		for(route in routeCollection)
		{
			var data = route.getRouteData(httpContext);
			if (data == null) continue;
			
			var requestContext = new RequestContext(httpContext, data);
			httpHandler = data.routeHandler.getHttpHandler(requestContext);
			
			return;
		}

		throw new PageNotFoundError();
	}
	
	function executeHttpHandler(application : HttpApplication)
	{		
		httpHandler.processRequest(application.httpContext);
	}
	
	public function dispose() : Void
	{
		routeCollection = null;
		httpHandler = null;
	}
}