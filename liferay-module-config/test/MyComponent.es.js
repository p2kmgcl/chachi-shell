import Component from 'metal-component';
import Soy from 'metal-soy';
import templates from './MyComponent.soy';
import {Config} from 'metal-state';

/**
 * MyComponent
 */
class MyComponent extends Component {

	/**
	 * Do things
	 * @param {string[]} things
	 * @review
	 */
	static doThings(things) {
		things.forEach(thing => {
			MyComponent.doThing(thing);
		});
	}

	/**
	 * @param {string} thing
	 */
	static doThing(thing) {
		if (confirm(`Do ${thing}?`)) {
			alert(`${thing} done`);
		}
	}

	/**
	 * @inheritdoc
	 */
	rendered() {
		this._doThings();
	}

	/**
	 * @inheritdoc
	 * @return {boolean}
	 */
	shouldUpdate(changes) {
		return 'things' in changes;
	}

	/**
	 * Things property changes
	 */
	syncThings() {
		const b = 1;
		const a = 2;

		console.log(a, b);
		this._done = false;
	}

	/** */
	_handleOa() {
		alert('ea');
	}

	/** */
	_handleEa() {
		alert('ea');
	}

	/**
	 * Do things
	 * @private
	 */
	_doThings() {
		if (!this._done) {
			// Newline here needed
			this._done = true;
			MyComponent.doThings(this.things);
		}
	}

}

MyComponent.STATE = {
	_done: Config.boolean()
		.internal()
		.value(false),

	things: Config.arrayOf(
		Config.string()
	)
		.value([])
};

Soy.register(MyComponent, templates);

export {MyComponent};
export default MyComponent;