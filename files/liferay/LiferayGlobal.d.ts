interface EventHandler {
	removeListener: () => void;
}

interface Sidebar {
	visible: () => true;
	on: (event: string, handler: Function) => EventHandler;
}

interface ILiferay {
	Language: {
		get: (key: string) => string;
	};

	SideNavigation: {
		hide: (node: Element) => void;
		instance: (node: Element) => Sidebar;
	};

	ThemeDisplay: {
		getBCP47LanguageId: () => string;
	};
}

declare global {
	export const Liferay: ILiferay;
}

export {};
