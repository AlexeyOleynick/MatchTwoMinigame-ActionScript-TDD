package {

	import core.external.texture.EmbedSpriteSheetInfoProvider;
	import core.external.texture.ISpriteSheetInfoProvider;
	import core.external.texture.ITextureService;
	import core.external.texture.SpriteSheetTextureService;
	import core.signal.StartupSignal;
	import core.stage.BasicContextModel;
	import core.stage.IContextModel;
	import core.stage.StarlingRootMediator;
	import core.stage.StarlingStageView;
	import core.stage.signal.AddToStageSignal;
	import core.stage.signal.EnterFrameSignal;

	import game.level.card.model.ICardCollection;
	import game.level.card.model.VectorCardCollection;
	import game.level.card.signal.CardsCreatedSignal;
	import game.level.card.signal.CardsMatchedSignal;
	import game.level.card.signal.CardsRemovedSignal;
	import game.level.card.signal.CardsUpdatedSignal;
	import game.level.card.view.CardMediator;
	import game.level.card.view.CardView;
	import game.level.card.view.ICardView;
	import game.level.card.view.IStateView;
	import game.level.card.view.TextureStateView;
	import game.level.field.controller.AddFieldCommand;
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
	import game.level.field.signal.AddFieldSignal;
	import game.level.field.view.FieldMediator;
	import game.level.field.view.IFieldContainer;
	import game.level.field.view.factory.DefaultCardViewFactory;
	import game.level.field.view.factory.ICardViewFactory;
	import game.startup.StartupCommand;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.bender.framework.api.LogLevel;

	public class AppConfig implements IConfig {
		[Inject]
		public var context:IContext;

		[Inject]
		public var commandMap:ISignalCommandMap;

		[Inject]
		public var mediatorMap:IMediatorMap;

		[Inject]
		public var injector:IInjector;

		[Inject]
		public var logger:ILogger;

		[Inject]
		public var contextView:ContextView;

		public function configure():void
		{
			context.logLevel = LogLevel.DEBUG;
			logger.info("configuring application");

			injector.map(ISignal).toType(Signal);

			injector.map(EnterFrameSignal).asSingleton();
			injector.map(AddToStageSignal).asSingleton();

			injector.map(CardsCreatedSignal).asSingleton();
			injector.map(CardsMatchedSignal).asSingleton();
			injector.map(CardsRemovedSignal).asSingleton();
			injector.map(CardsUpdatedSignal).asSingleton();

			injector.map(ICardViewFactory).toSingleton(DefaultCardViewFactory);

			commandMap.map(StartupSignal).toCommand(StartupCommand);
			commandMap.map(AddFieldSignal).toCommand(AddFieldCommand);

			mediatorMap.map(StarlingStageView).toMediator(StarlingRootMediator);
			mediatorMap.map(ICardView).toMediator(CardMediator);
//			injector.map(ICardView).toType(CardView);
			mediatorMap.map(IFieldContainer).toMediator(FieldMediator);

			injector.map(IContextModel).toSingleton(BasicContextModel);
			injector.map(IStateView).toType(TextureStateView);
			injector.map(ISolutionService).toSingleton(RandomSolutionService);
			injector.map(IBoundsService).toSingleton(RectangleBoundsService);
			injector.map(ICardsModel).toSingleton(DefaultCardsModel);
			injector.map(ITextureService).toSingleton(SpriteSheetTextureService);

			injector.map(ICardFilter, 'REMOVAL').toSingleton(RemovalFilter);
			injector.map(ICardUpdater).toSingleton(CardPositionUpdater);
			injector.map(ICardProducer).toSingleton(InsideBoundsCardProducer);
			injector.map(ICardCollection).toSingleton(VectorCardCollection);

			injector.map(ISpriteSheetInfoProvider).toSingleton(EmbedSpriteSheetInfoProvider);
		}
	}
}
