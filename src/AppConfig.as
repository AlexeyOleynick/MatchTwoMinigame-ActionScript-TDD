package {

	import core.external.texture.EmbedSpriteSheetInfoProvider;
	import core.external.texture.ISpriteSheetInfoProvider;
	import core.external.texture.ITextureService;
	import core.external.texture.SpriteSheetTextureService;
	import core.stage.BasicContextModel;
	import core.stage.IContextModel;
	import core.stage.StarlingRootMediator;
	import core.stage.StarlingStageView;

	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import game.level.card.controller.DisplayCardCommand;
	import game.level.card.model.CardsEvent;
	import game.level.card.model.CardsEventType;
	import game.level.card.model.ICardCollection;
	import game.level.card.model.VectorCardCollection;
	import game.level.card.view.CardMediator;
	import game.level.card.view.CardView;
	import game.level.card.view.ICardView;
	import game.level.card.view.IStateView;
	import game.level.card.view.TextureStateView;
	import game.level.field.controller.AddFieldCommand;
	import game.level.field.controller.GameEventType;
	import game.level.field.model.DefaultCardsModel;
	import game.level.field.model.ICardsModel;
	import game.level.field.model.bounds.IBoundsService;
	import game.level.field.model.bounds.RectangleBoundsService;
	import game.level.field.model.filter.ICardFilter;
	import game.level.field.model.filter.RemovalFilter;
	import game.level.field.model.generator.ICardProducer;
	import game.level.field.model.generator.InsideBoundsCardProducer;
	import game.level.field.model.solution.ISolutionService;
	import game.level.field.model.solution.RandomSolutionService;
	import game.level.field.model.updater.CardPositionUpdater;
	import game.level.field.model.updater.ICardUpdater;
	import game.level.field.view.FieldMediator;
	import game.level.field.view.IFieldContainer;
	import game.startup.StartupCommand;
	import game.startup.StartupEventType;

	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.bender.framework.api.LogLevel;

	public class AppConfig implements IConfig {
		[Inject]
		public var context:IContext;

		[Inject]
		public var commandMap:IEventCommandMap;

		[Inject]
		public var mediatorMap:IMediatorMap;

		[Inject]
		public var injector:IInjector;

		[Inject]
		public var logger:ILogger;

		[Inject]
		public var contextView:ContextView;

		[Inject]
		public var dispatcher:IEventDispatcher;

		public function configure():void
		{
			context.logLevel = LogLevel.DEBUG;
			logger.info("configuring application");

			commandMap.map(GameEventType.ADD_FIELD).toCommand(AddFieldCommand);
			commandMap.map(StartupEventType.STARTUP).toCommand(StartupCommand);
			commandMap.map(CardsEventType.CREATED, CardsEvent).toCommand(DisplayCardCommand);

			mediatorMap.map(StarlingStageView).toMediator(StarlingRootMediator);
			mediatorMap.map(ICardView).toMediator(CardMediator);
			injector.map(ICardView, 'not for mediator').toType(CardView);
			mediatorMap.map(IFieldContainer).toMediator(FieldMediator);

			injector.map(IContextModel).toSingleton(BasicContextModel);
			injector.map(IStateView).toType(TextureStateView);
			injector.map(ISolutionService).toSingleton(RandomSolutionService);
			injector.map(IBoundsService).toSingleton(RectangleBoundsService);
			injector.map(ICardsModel).toSingleton(DefaultCardsModel);
			injector.map(ITextureService).toSingleton(SpriteSheetTextureService);
			injector.map(EventDispatcher, 'local').toType(EventDispatcher);

			injector.map(ICardFilter, 'removal filter').toSingleton(RemovalFilter);
			injector.map(ICardUpdater).toSingleton(CardPositionUpdater);
			injector.map(ICardProducer).toSingleton(InsideBoundsCardProducer);
			injector.map(ICardCollection).toSingleton(VectorCardCollection);

			injector.map(ISpriteSheetInfoProvider).toSingleton(EmbedSpriteSheetInfoProvider);
		}
	}
}
