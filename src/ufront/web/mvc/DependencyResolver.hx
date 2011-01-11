package ufront.web.mvc;

/**
 * ...
 * @author Andreas Soderlund
 */

class DependencyResolver 
{
	public static var current : IDependencyResolver = new DefaultDependencyResolver();

	public static function setResolver(resolver : IDependencyResolver)
	{
		DependencyResolver.current = resolver;
		return resolver;
	}
}
