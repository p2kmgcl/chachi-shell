declare module 'frontend-js-react-web' {
	export function useIsMounted(): () => true;

	export function useEventListener(
		event: string,
		handler: Function,
		capture?: boolean,
		element?: Element | Window
	): () => void;
}

declare module 'frontend-js-web' {
	interface IOpenToastOptions {
		message: string;
		title: string;
		type: 'danger';
	}

	export function openToast(options: IOpenToastOptions): void;
	export function throttle(fn: Function, delay: number): void;
}
