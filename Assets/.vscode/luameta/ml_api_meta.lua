--- @meta
--- @diagnostic enable spell-check
--- Copyright The HumanMode LLC 2023 

--- Creates number type serialized field, **Not a real type**
---@class Number : number
local Number = {}
---@cast Number +number, -Number, -table

--- Creates a string type serialized field, **Not a real type**
---@class String : string
local String = {}
---@cast String +string, -String, -table

--- Creates a boolean type serialized field, **Not a real type**
---@class Bool : boolean
local Bool = {}
---@cast Bool +boolean, -Bool, -table


--- Create a serialized field that can be assigned values in Unity Inspector.
--- @generic T 
--- @param name string the name of the serialized field;
--- @param type T the type of serialized field
--- @return T value value of serialized field
function SerializedField(name, type)end

--- Create a serialized field array that can be assigned values in Unity Inspector
--- @generic T 
--- @param name string the name of the serialized field;
--- @param type T the type of serialized field
--- @param arrayCount integer the number of arrays
--- @return T[] value an array of values of serialized field starting from index 1
function SerializedField(name, type, arrayCount)end

--- ##### Type *AnimationClip* inherits *Motion*
--- ***
--- Stores keyframe based animations.
--- @class AnimationClip
--- @field empty boolean Returns true if the animation clip has no curves and no events.
--- @field events AnimationEvent[] Animation Events for this animation clip.
--- @field frameRate number Frame rate at which keyframes are sampled. (Read Only)
--- @field hasGenericRootTransform boolean Returns true if the Animation has animation on the root transform.
--- @field hasMotionCurves boolean Returns true if the AnimationClip has root motion curves.
--- @field humanMotion boolean Returns true if the animation contains curve that drives a humanoid rig.
--- @field legacy boolean Set to true if the AnimationClip will be used with the Legacy Animation component ( instead of the Animator ).
--- @field length number Animation length in seconds. (Read Only)
--- @field localBounds Bounds AABB of this Animation Clip in local space of Animation component that it is attached too.
--- @field wrapMode WrapMode Sets the default wrap mode used in the animation state.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
AnimationClip = {}

--- ##### Constructor for *AnimationClip*
--- ***
--- Creates a new animation clip.
--- @return AnimationClip
function AnimationClip() end

--- ##### Method
--- ***
--- Adds an animation event to the clip.
--- @param evt AnimationEvent AnimationEvent to add.
function AnimationClip.AddEvent(evt) end

--- ##### Method
--- ***
--- Clears all curves from the clip.
function AnimationClip.ClearCurves() end

--- ##### Method
--- ***
--- Realigns quaternion keys to ensure shortest interpolation paths.
function AnimationClip.EnsureQuaternionContinuity() end

--- ##### Method
--- ***
--- Samples an animation at a given time for any animated properties.
--- @param go GameObject The animated game object.
--- @param time number The time to sample an animation.
function AnimationClip.SampleAnimation(go, time) end

--- ##### Method
--- ***
--- Assigns the curve to animate a specific property.
--- @param relativePath string Path to the game object this curve applies to. The relativePath is formatted similar to a pathname, e.g. "root/spine/leftArm". If relativePath is empty it refers to the game object the animation clip is attached to.
--- @param type userdata The class type of the component that is animated.
--- @param propertyName string The name or path to the property being animated.
--- @param curve AnimationCurve The animation curve.
function AnimationClip.SetCurve(relativePath, type, propertyName, curve) end

--- ##### Method Inherited from *Motion*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function AnimationClip.GetInstanceID() end

--- ##### Type *AnimationCurve*
--- ***
--- Store a collection of Keyframes that can be evaluated over time.
--- @class AnimationCurve
--- @field keys Keyframe[] All keys defined in the animation curve.
--- @field length number The number of keys in the curve. (Read Only)
--- @field postWrapMode WrapMode The behaviour of the animation after the last keyframe.
--- @field preWrapMode WrapMode The behaviour of the animation before the first keyframe.
AnimationCurve = {}

--- ##### Constructor for *AnimationCurve*
--- ***
--- Creates an animation curve from an arbitrary number of keyframes.
--- @param keys Keyframe[] An array of Keyframes used to define the curve.
--- @return AnimationCurve
function AnimationCurve(keys) end

--- ##### Constructor for *AnimationCurve*
--- ***
--- Creates an empty animation curve.
--- @return AnimationCurve
function AnimationCurve() end

--- ##### Method
--- ***
--- Add a new key to the curve.
--- @param time number The time at which to add the key (horizontal axis in the curve graph).
--- @param value number The value for the key (vertical axis in the curve graph).
--- @return number # The index of the added key, or -1 if the key could not be added.
function AnimationCurve.AddKey(time, value) end

--- ##### Method
--- ***
--- Add a new key to the curve.
--- @param key Keyframe The key to add to the curve.
--- @return number # The index of the added key, or -1 if the key could not be added.
function AnimationCurve.AddKey(key) end

--- ##### Method
--- ***
--- Evaluate the curve at `time`.
--- @param time number The time within the curve you want to evaluate (the horizontal axis in the curve graph).
--- @return number # The value of the curve, at the point in time specified.
function AnimationCurve.Evaluate(time) end

--- ##### Method
--- ***
--- Removes the keyframe at index and inserts key.
--- @param index number The index of the key to move.
--- @param key Keyframe The key (with its new time) to insert.
--- @return number # The index of the keyframe after moving it.
function AnimationCurve.MoveKey(index, key) end

--- ##### Method
--- ***
--- Removes a key.
--- @param index number The index of the key to remove.
function AnimationCurve.RemoveKey(index) end

--- ##### Method
--- ***
--- Smooth the in and out tangents of the keyframe at index. <br> A weight of 0 evens out tangents.
--- @param index number The index of the keyframe to be smoothed.
--- @param weight number The smoothing weight to apply to the keyframe's tangents.
function AnimationCurve.SmoothTangents(index, weight) end

--- ##### Static Method
--- ***
--- Creates a constant "curve" starting at timeStart, ending at timeEnd and with the value value.
--- @param timeStart number The start time for the constant curve.
--- @param timeEnd number The start time for the constant curve.
--- @param value number The value for the constant curve.
--- @return AnimationCurve # The constant curve created from the specified values.
function AnimationCurve:Constant(timeStart, timeEnd, value) end

--- ##### Static Method
--- ***
--- Creates an ease-in and out curve starting at timeStart, valueStart and ending at timeEnd, valueEnd.
--- @param timeStart number The start time for the ease curve.
--- @param valueStart number The start value for the ease curve.
--- @param timeEnd number The end time for the ease curve.
--- @param valueEnd number The end value for the ease curve.
--- @return AnimationCurve # The ease-in and out curve generated from the specified values.
function AnimationCurve:EaseInOut(timeStart, valueStart, timeEnd, valueEnd) end

--- ##### Static Method
--- ***
--- A straight Line starting at timeStart, valueStart and ending at timeEnd, valueEnd. 
--- @param timeStart number The start time for the linear curve.
--- @param valueStart number The start value for the linear curve.
--- @param timeEnd number The end time for the linear curve.
--- @param valueEnd number The end value for the linear curve.
--- @return AnimationCurve # The linear curve created from the specified values.
function AnimationCurve:Linear(timeStart, valueStart, timeEnd, valueEnd) end

--- ##### Type *AnimationEvent*
--- ***
--- AnimationEvent lets you call a script function similar to SendMessage as part of playing back an animation.
--- @class AnimationEvent
--- @field animationState AnimationState The animation state that fired this event (Read Only).
--- @field animatorClipInfo AnimatorClipInfo The animator clip info related to this event (Read Only).
--- @field animatorStateInfo AnimatorStateInfo The animator state info related to this event (Read Only).
--- @field floatParameter number Float parameter that is stored in the event and will be sent to the function.
--- @field functionName string The name of the function that will be called.
--- @field intParameter number Int parameter that is stored in the event and will be sent to the function.
--- @field isFiredByAnimator boolean Returns true if this Animation event has been fired by an Animator component.
--- @field isFiredByLegacy boolean Returns true if this Animation event has been fired by an Animation component.
--- @field messageOptions SendMessageOptions Function call options.
--- @field objectReferenceParameter Object Object reference parameter that is stored in the event and will be sent to the function.
--- @field stringParameter string String parameter that is stored in the event and will be sent to the function.
--- @field time number The time at which the event will be fired off.
AnimationEvent = {}

--- ##### Constructor for *AnimationEvent*
--- ***
--- Creates a new animation event.
--- @return AnimationEvent
function AnimationEvent() end

--- ##### Type *AnimationState*
--- ***
--- The AnimationState gives full control over animation blending.
--- @class AnimationState
--- @field blendMode AnimationBlendMode Which blend mode should be used?
--- @field clip AnimationClip The clip that is being played by this animation state.
--- @field enabled boolean Enables / disables the animation.
--- @field length number The length of the animation clip in seconds.
--- @field name string The name of the animation.
--- @field normalizedSpeed number The normalized playback speed.
--- @field normalizedTime number The normalized time of the animation.
--- @field speed number The playback speed of the animation. 1 is normal playback speed. 
--- @field time number The current time of the animation.
--- @field weight number The weight of animation.
--- @field wrapMode WrapMode Wrapping mode of the animation.
AnimationState = {}

--- ##### Method
--- ***
--- Adds a transform which should be animated. This allows you to reduce the number of animations you have to create.
--- @param mix Transform The transform to animate.
--- @param recursive boolean? **Optional**(default = true) Whether to also animate all children of the specified transform.
function AnimationState.AddMixingTransform(mix, recursive) end

--- ##### Method
--- ***
--- Removes a transform which should be animated.
--- @param mix Transform Transform mix to remove. 
function AnimationState.RemoveMixingTransform(mix) end

--- ##### Type *Animator* inherits *Behaviour*
--- ***
--- Interface to control the Mecanim animation system. [Unity Animator](https://docs.unity3d.com/ScriptReference/Animator.html)
--- @class Animator
--- @field angularVelocity Vector3 Gets the avatar angular velocity for the last evaluated frame.
--- @field applyRootMotion boolean Should root motion be applied?
--- @field avatar Avatar Gets/Sets the current Avatar.
--- @field bodyPosition Vector3 The position of the body center of mass.
--- @field bodyRotation Quaternion The rotation of the body center of mass.
--- @field cullingMode AnimatorCullingMode Controls culling of this Animator component.
--- @field deltaPosition Vector3 Gets the avatar delta position for the last evaluated frame.
--- @field deltaRotation Quaternion Gets the avatar delta rotation for the last evaluated frame.
--- @field feetPivotActive number Blends pivot point between body center of mass and feet pivot.
--- @field fireEvents boolean Sets whether the Animator sends events of type AnimationEvent.
--- @field gravityWeight number The current gravity weight based on current animations that are played.
--- @field hasBoundPlayables boolean Returns true if Animator has any playables assigned to it.
--- @field hasRootMotion boolean Returns true if the current rig has root motion.
--- @field hasTransformHierarchy boolean Returns true if the object has a transform hierarchy.
--- @field humanScale number Returns the scale of the current Avatar for a humanoid rig, (1 by default if the rig is generic).
--- @field isHuman boolean Returns true if the current rig is humanoid, false if it is generic.
--- @field isInitialized boolean Returns whether the animator is initialized successfully.
--- @field isMatchingTarget boolean If automatic matching is active.
--- @field isOptimizable boolean Returns true if the current rig is optimizable with AnimatorUtility.OptimizeTransformHierarchy.
--- @field keepAnimatorControllerStateOnDisable boolean Controls the behaviour of the Animator component when a GameObject is disabled.
--- @field layerCount number Returns the number of layers in the controller.
--- @field layersAffectMassCenter boolean Additional layers affects the center of mass.
--- @field leftFeetBottomHeight number Get left foot bottom height.
--- @field parameterCount number Returns the number of parameters in the controller.
--- @field parameters AnimatorControllerParameter[] **Read-Only**  |  The AnimatorControllerParameter list used by the animator. (Read Only)
--- @field pivotPosition Vector3 Get the current position of the pivot.
--- @field pivotWeight number Gets the pivot weight.
--- @field playbackTime number Sets the playback position in the recording buffer.
--- @field rightFeetBottomHeight number Get right foot bottom height.
--- @field rootPosition Vector3 The root position, the position of the game object.
--- @field rootRotation Quaternion The root rotation, the rotation of the game object.
--- @field runtimeAnimatorController RuntimeAnimatorController The runtime representation of AnimatorController that controls the Animator.
--- @field speed number The playback speed of the Animator. 1 is normal playback speed.
--- @field stabilizeFeet boolean Automatic stabilization of feet during transition and blending.
--- @field targetPosition Vector3 Returns the position of the target specified by SetTarget.
--- @field targetRotation Quaternion Returns the rotation of the target specified by SetTarget.
--- @field updateMode AnimatorUpdateMode Specifies the update mode of the Animator.
--- @field velocity boolean Gets the avatar velocity for the last evaluated frame.
--- @field enabled boolean **Inherited**  |  Enabled Behaviours are Updated, disabled Behaviours are not.
--- @field isActiveAndEnabled boolean **Inherited**  |  Has the Behaviour had active and enabled called?
--- @field gameObject GameObject **Read-Only**  **Inherited**  |  The game object this component is attached to. A component is always attached to a game object.
--- @field tag string **Read-Only**  **Inherited**  |  The tag of this game object.
--- @field transform Transform **Read-Only**  **Inherited**  |  The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
Animator = {}

--- ##### Method
--- ***
--- Apply the default Root Motion.
function Animator.ApplyBuiltinRootMotion() end

--- ##### Method
--- ***
--- Creates a crossfade from the current state to any other state using normalized times.
--- @param stateName string The name of the state.
--- @param normalizedTransitionDuration number The duration of the transition (normalized).
--- @param layer number? **Optional**(default = -1) The layer where the crossfade occurs.
--- @param normalizedTimeOffset number? **Optional**(default = 0) The time of the state (normalized).
--- @param normalizedTransitionTime number? **Optional**(default = 0) The time of the transition (normalized).
function Animator.CrossFade(stateName, normalizedTransitionDuration, layer, normalizedTimeOffset, normalizedTransitionTime) end

--- ##### Method
--- ***
--- Creates a crossfade from the current state to any other state using times in seconds.
--- @param stateName string The name of the state.
--- @param fixedTransitionDuration number The duration of the transition (in seconds).
--- @param layer number? **Optional**(default = -1) The layer where the crossfade occurs.
--- @param fixedTimeOffset number? **Optional**(default = 0) The time of the state (in seconds).
--- @param normalizedTransitionTime number? **Optional**(default = 0) The time of the transition (normalized).
function Animator.CrossFadeInFixedTime(stateName, fixedTransitionDuration, layer, fixedTimeOffset, normalizedTransitionTime) end

--- ##### Method
--- ***
--- Returns an AnimatorTransitionInfo with the informations on the current transition.
--- @param layerIndex number The layer's index.
--- @return AnimatorTransitionInfo # An AnimatorTransitionInfo with the informations on the current transition.
function Animator.GetAnimatorTransitionInfo(layerIndex) end

--- ##### Method
--- ***
--- Returns Transform mapped to this human bone id. Returns null if the animator is disabled, if it does not have a human description, or if the bone id is invalid.
--- @param humanBoneId HumanBodyBones The human bone that is queried, see enum HumanBodyBones for a list of possible values.
--- @return Transform #  Transform mapped to this human bone id. Returns null if the animator is disabled, if it does not have a human description, or if the bone id is invalid.
function Animator.GetBoneTransform(humanBoneId) end

--- ##### Method
--- ***
--- Returns the value of the given boolean parameter.
--- @param name string The parameter name.
--- @return boolean # The value of the parameter.
function Animator.GetBool(name) end

--- ##### Method
--- ***
--- Returns an array of all the AnimatorClipInfo in the current state of the given layer.
--- @param layerIndex number The layer index.
--- @return AnimatorClipInfo[] # an array of all the AnimatorClipInfo in the current state of the given layer.
function Animator.GetCurrentAnimatorClipInfo(layerIndex) end

--- ##### Method
--- ***
--- Returns the number of AnimatorClipInfo in the current state.
--- @param layerIndex number The layer index.
--- @return number # The number of AnimatorClipInfo in the current state.
function Animator.GetCurrentAnimatorClipInfoCount(layerIndex) end

--- ##### Method
--- ***
--- Returns an AnimatorStateInfo with the information on the current state.
--- @param layerIndex number The layer index.
--- @return AnimatorStateInfo # An AnimatorStateInfo with the information on the current state.
function Animator.GetCurrentAnimatorStateInfo(layerIndex) end

--- ##### Method
--- ***
--- Returns the value of the given float parameter.
--- @param name string The parameter name.
--- @return number # The value of the parameter.
function Animator.GetFloat(name) end

--- ##### Method
--- ***
--- Gets the position of an IK hint.
--- @param hint AvatarIKHint The AvatarIKHint that is queried.
--- @return Vector3 # Return the current position of this IK hint in world space.
function Animator.GetIKHintPosition(hint) end

--- ##### Method
--- ***
--- Gets the translative weight of an IK Hint (0 = at the original animation before IK, 1 = at the hint).
--- @param hint AvatarIKHint The AvatarIKHint that is queried.
--- @return number # Return translative weight.
function Animator.GetIKHintPositionWeight(hint) end

--- ##### Method
--- ***
--- Gets the position of an IK goal.
--- @param goal AvatarIKGoal The AvatarIKGoal that is queried.
--- @return Vector3 # Return the current position of this IK goal in world space.
function Animator.GetIKPosition(goal) end

--- ##### Method
--- ***
--- Gets the translative weight of an IK goal (0 = at the original animation before IK, 1 = at the goal).
--- @param goal AvatarIKGoal The AvatarIKGoal that is queried.
--- @return number # translative weight of an IK goal
function Animator.GetIKPositionWeight(goal) end

--- ##### Method
--- ***
--- Gets the rotation of an IK goal.
--- @param goal AvatarIKGoal The AvatarIKGoal that is is queried.
--- @return Quaternion # rotation of an IK goal.
function Animator.GetIKRotation(goal) end

--- ##### Method
--- ***
--- Gets the rotational weight of an IK goal (0 = rotation before IK, 1 = rotation at the IK goal).
--- @param goal AvatarIKGoal The AvatarIKGoal that is queried.
--- @return number # rotational weight of the IK goal
function Animator.GetIKRotationWeight(goal) end

--- ##### Method
--- ***
--- Returns the value of the given integer parameter.
--- @param name string The parameter name.
--- @return number # The value of the parameter.
function Animator.GetInteger(name) end

--- ##### Method
--- ***
--- Returns the index of the layer with the given name.
--- @param layerName string The layer name.
--- @return number # The layer index.
function Animator.GetLayerIndex(layerName) end

--- ##### Method
--- ***
--- Returns the layer name.
--- @param layerIndex number The layer index.
--- @return string # The layer name.
function Animator.GetLayerName(layerIndex) end

--- ##### Method
--- ***
--- Returns the weight of the layer at the specified index.
--- @param layerIndex number The layer index.
--- @return number # The layer weight.
function Animator.GetLayerWeight(layerIndex) end

--- ##### Method
--- ***
--- Returns an array of all the AnimatorClipInfo in the next state of the given layer.
--- @param layerIndex number The layer index.
--- @return AnimatorClipInfo[] # An array of all the AnimatorClipInfo in the next state.
function Animator.GetNextAnimatorClipInfo(layerIndex) end

--- ##### Method
--- ***
--- Returns the number of AnimatorClipInfo in the next state.
--- @param layerIndex number The layer index.
--- @return number # The number of AnimatorClipInfo in the next state.
function Animator.GetNextAnimatorClipInfoCount(layerIndex) end

--- ##### Method
--- ***
--- Returns an AnimatorStateInfo with the information on the next state.
--- @param layerIndex number The layer index.
--- @return AnimatorStateInfo # An AnimatorStateInfo with the information on the next state.
function Animator.GetNextAnimatorStateInfo(layerIndex) end

--- ##### Method
--- ***
--- Get animator controller parameter. 
--- @param index number index
--- @return AnimatorControllerParameter # parameter
function Animator.GetParameter(index) end

--- ##### Method
--- ***
--- Returns true if the state exists in this layer, false otherwise.
--- @param layerIndex number The layer index.
--- @param stateID number The state ID.
--- @return boolean # True if the state exists in this layer, false otherwise.
function Animator.HasState(layerIndex, stateID) end

--- ##### Method
--- ***
--- Interrupts the automatic target matching.
--- @param completeMatch boolean CompleteMatch will make the gameobject match the target completely at the next frame.
function Animator.InterruptMatchTarget(completeMatch) end

--- ##### Method
--- ***
--- Returns true if there is a transition on the given layer, false otherwise.
--- @param layerIndex number The layer index.
--- @return boolean # True if there is a transition on the given layer, false otherwise.
function Animator.IsInTransition(layerIndex) end

--- ##### Method
--- ***
--- Returns true if the parameter is controlled by a curve, false otherwise.
--- @param name string The parameter name.
--- @return boolean # True if the parameter is controlled by a curve, false otherwise.
function Animator.IsParameterControlledByCurve(name) end

--- ##### Method
--- ***
--- Automatically adjust the GameObject position and rotation.
--- @param matchPosition Vector3 The position we want the body part to reach.
--- @param matchRotation Quaternion The rotation in which we want the body part to be.
--- @param targetBodyPart AvatarTarget The body part that is involved in the match.
--- @param positionXYZWeight  Vector3 weights for matching position
--- @param rotationWeight number Rotation weight.
--- @param startNormalizedTime number Start time within the animation clip (0 - beginning of clip, 1 - end of clip).
--- @param targetNormalizedTime number End time within the animation clip (0 - beginning of clip, 1 - end of clip), values greater than 1 can be set to trigger a match after a certain number of loops. Ex: 2.3 means at 30% of 2nd loop.
--- @param completeMatch number? **Optional**(default = 1) Allows you to specify what should happen if the MatchTarget function is interrupted. A value of true causes the GameObject to immediately move to the matchPosition if interrupted. A value of false causes the GameObject to stay at its current position if interrupted.
function Animator.MatchTarget(matchPosition, matchRotation, targetBodyPart, positionXYZWeight , rotationWeight, startNormalizedTime, targetNormalizedTime, completeMatch) end

--- ##### Method
--- ***
--- Plays a state.
--- @param stateName string The state name.
--- @param layer number The layer index. If layer is -1, it plays the first state with the given state name or hash.
--- @param normalizedTime number? **Optional**(default = -#INF) The time offset between zero and one.
function Animator.Play(stateName, layer, normalizedTime) end

--- ##### Method
--- ***
--- Plays a state.
--- @param stateName string The state name.
--- @param layer number? **Optional**(default = -1) The layer index. If layer is -1, it plays the first state with the given state name or hash.
--- @param fixedTime number? **Optional**(default = -#INF) The time offset (in seconds).
function Animator.PlayInFixedTime(stateName, layer, fixedTime) end

--- ##### Method
--- ***
--- Rebind all the animated properties and mesh data with the Animator.
function Animator.Rebind() end

--- ##### Method
--- ***
--- Resets the value of the given trigger parameter.
--- @param name string The parameter name.
function Animator.ResetTrigger(name) end

--- ##### Method
--- ***
--- Sets local rotation of a human bone during a IK pass.
--- @param humanBoneId HumanBodyBones The human bone Id.
--- @param rotation Quaternion The local rotation.
function Animator.SetBoneLocalRotation(humanBoneId, rotation) end

--- ##### Method
--- ***
--- Sets the value of the given boolean parameter.
--- @param name string The parameter name.
--- @param value boolean The new parameter value.
function Animator.SetBool(name, value) end

--- ##### Method
--- ***
--- Send float values to the Animator to affect transitions.
--- @param name string The parameter name.
--- @param value number The new parameter value.
function Animator.SetFloat(name, value) end

--- ##### Method
--- ***
--- Send float values to the Animator to affect transitions.
--- @param name string The parameter name.
--- @param value number The new parameter value.
--- @param dampTime number The damper total time.
--- @param deltaTime number The delta time to give to the damper.
function Animator.SetFloat(name, value, dampTime, deltaTime) end

--- ##### Method
--- ***
--- Sets the position of an IK hint.
--- @param hint AvatarIKHint The AvatarIKHint that is set.
--- @param hintPosition Vector3 The position in world space.
function Animator.SetIKHintPosition(hint, hintPosition) end

--- ##### Method
--- ***
--- Sets the translative weight of an IK hint (0 = at the original animation before IK, 1 = at the hint).
--- @param hint AvatarIKHint The AvatarIKHint that is set.
--- @param value number The translative weight.
function Animator.SetIKHintPositionWeight(hint, value) end

--- ##### Method
--- ***
--- Sets the position of an IK goal.
--- @param goal AvatarIKGoal The AvatarIKGoal that is set.
--- @param goalPosition Vector3 The position in world space.
function Animator.SetIKPosition(goal, goalPosition) end

--- ##### Method
--- ***
--- Sets the translative weight of an IK goal (0 = at the original animation before IK, 1 = at the goal).
--- @param goal AvatarIKGoal The AvatarIKGoal that is set.
--- @param value number The translative weight.
function Animator.SetIKPositionWeight(goal, value) end

--- ##### Method
--- ***
--- Sets the rotation of an IK goal.
--- @param goal AvatarIKGoal The AvatarIKGoal that is set.
--- @param goalRotation Quaternion The rotation in world space.
function Animator.SetIKRotation(goal, goalRotation) end

--- ##### Method
--- ***
--- Sets the rotational weight of an IK goal (0 = rotation before IK, 1 = rotation at the IK goal).
--- @param goal AvatarIKGoal The AvatarIKGoal that is set.
--- @param value number The rotational weight.
function Animator.SetIKRotationWeight(goal, value) end

--- ##### Method
--- ***
--- Sets the value of the given integer parameter.
--- @param name string The parameter name.
--- @param value number The new parameter value.
function Animator.SetInteger(name, value) end

--- ##### Method
--- ***
--- Sets the weight of the layer at the given index.
--- @param layerIndex number The layer index.
--- @param weight number The new layer weight.
function Animator.SetLayerWeight(layerIndex, weight) end

--- ##### Method
--- ***
--- Sets the look at position. 
--- @param lookAtPosition Vector3 The position to lookAt.
function Animator.SetLookAtPosition(lookAtPosition) end

--- ##### Method
--- ***
--- Set look at weights. 
--- @param weight number (0-1) the global weight of the LookAt, multiplier for other parameters.
--- @param bodyWeight number? **Optional**(default = 0) (0-1) determines how much the body is involved in the LookAt.
--- @param headWeight number? **Optional**(default = 1) (0-1) determines how much the head is involved in the LookAt.
--- @param eyesWeight number? **Optional**(default = 0) (0-1) determines how much the eyes are involved in the LookAt.
--- @param clampWeight number? **Optional**(default = 0.5) (0-1) 0.0 means the character is completely unrestrained in motion, 1.0 means he's completely clamped (look at becomes impossible), and 0.5 means he'll be able to move on half of the possible range (180 degrees).
function Animator.SetLookAtWeight(weight, bodyWeight, headWeight, eyesWeight, clampWeight) end

--- ##### Method
--- ***
--- Sets an AvatarTarget and a targetNormalizedTime for the current state.
--- @param targetIndex AvatarTarget The avatar body part that is queried.
--- @param targetNormalizedTime number The current state Time that is queried.
function Animator.SetTarget(targetIndex, targetNormalizedTime) end

--- ##### Method
--- ***
--- Sets the value of the given trigger parameter.
--- @param name string The parameter name.
function Animator.SetTrigger(name) end

--- ##### Method
--- ***
--- Sets the animator in playback mode.
function Animator.StartPlayback() end

--- ##### Method
--- ***
--- Stops the animator playback mode. When playback stops, the avatar resumes getting control from game logic.
function Animator.StopPlayback() end

--- ##### Method
--- ***
--- Evaluates the animator based on deltaTime.
--- @param deltaTime number The time delta.
function Animator.Update(deltaTime) end

--- ##### Method
--- ***
--- Forces a write of the default values stored in the animator.
function Animator.WriteDefaultValues() end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Calls the method named methodName on every Lua Script in this game object or any of its children.
--- @param methodName string Name of the method to call.
--- @param parameter any? **Optional**(default = nil) Optional parameter to pass to the method (can be any value).
function Animator.BroadcastMessage(methodName, parameter) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function Animator.CompareTag(tag) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # Array of all Lua scripts that attached to the game object.
function Animator.GetAllLuaScripts() end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the component of Type type if the game object has one attached, nil if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # the component of Type type
function Animator.GetComponent(type) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function Animator.GetComponentInChildren(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function Animator.GetComponentInParent(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function Animator.GetComponents(type) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function Animator.GetComponentsInChildren(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function Animator.GetComponentsInParent(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Calls the method named methodName on every Lua Script in this game object. 
--- @param methodName string Name of the method to call.
--- @param value any? **Optional**(default = nil) Optional parameter for the method.
function Animator.SendMessage(methodName, value) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Calls the method named methodName on every LuaScript in this game object and on every ancestor of the behaviour.
--- @param methodName string Name of method to call.
--- @param value any? **Optional**(default = nil) Optional parameter value for the method.
function Animator.SendMessageUpwards(methodName, value) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of the component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or nil.
function Animator.TryGetComponent(type) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function Animator.GetInstanceID() end

--- ##### Static Method
--- ***
--- Generates an parameter id from a string.
--- @param name string The string to convert to Id.
--- @return number # parameter id from the string.
function Animator:StringToHash(name) end

--- ##### Type *AnimatorClipInfo*
--- ***
--- Information about clip being played and blended by the Animator.
--- @class AnimatorClipInfo
--- @field clip AnimationClip Returns the animation clip played by the Animator.
--- @field weight number Returns the blending weight used by the Animator to blend this clip.
AnimatorClipInfo = {}

--- ##### Type *AnimatorControllerParameter*
--- ***
--- Used to communicate between scripting and the controller. Some parameters can be set in scripting and used by the controller, while other parameters are based on Custom Curves in Animation Clips and can be sampled using the scripting API.
--- @class AnimatorControllerParameter
--- @field defaultBool boolean The default bool value for the parameter.
--- @field defaultFloat number The default float value for the parameter.
--- @field defaultInt number The default int value for the parameter.
--- @field name string The name of the parameter.
--- @field nameHash number Returns the hash of the parameter based on its name.
--- @field type AnimatorControllerParameterType The type of the parameter.
AnimatorControllerParameter = {}

--- ##### Constructor for *AnimatorControllerParameter*
--- ***
--- Creates new AnimatorControllerParameter.
--- @return AnimatorControllerParameter
function AnimatorControllerParameter() end

--- ##### Type *AnimatorStateInfo*
--- ***
--- Information about the current or next state.
--- @class AnimatorStateInfo
--- @field fullPathHash number The full path hash for this state.
--- @field length number Current duration of the state.
--- @field loop boolean Is the state looping.
--- @field normalizedTime number Normalized time of the State.
--- @field shortNameHash number The hash is generated using Animator.StringToHash. The hash does not include the name of the parent layer.
--- @field speed number The playback speed of the animation. 1 is the normal playback speed.
--- @field speedMultiplier number The speed multiplier for this state.
--- @field tagHash number The Tag of the State.
AnimatorStateInfo = {}

--- ##### Method
--- ***
--- Does name match the name of the active state in the statemachine?
--- @param name string name
--- @return boolean # True if name match the name of the active state in the statemachine
function AnimatorStateInfo.IsName(name) end

--- ##### Method
--- ***
--- Does tag match the tag of the active state in the statemachine.
--- @param tag string tag
--- @return boolean # True if tag match the tag of the active state in the statemachine.
function AnimatorStateInfo.IsTag(tag) end

--- ##### Type *AnimatorTransitionInfo*
--- ***
--- Information about the current transition.
--- @class AnimatorTransitionInfo
--- @field anyState boolean Returns true if the transition is from an AnyState node, or from Animator.CrossFade.
--- @field duration number Duration of the transition.
--- @field durationUnit DurationUnit The unit of the transition duration.
--- @field fullPathHash number The hash name of the Transition.
--- @field nameHash number The simplified name of the Transition.
--- @field normalizedTime number Normalized time of the Transition.
--- @field userNameHash number The user-specified name of the Transition.
AnimatorTransitionInfo = {}

--- ##### Method
--- ***
--- Does name match the name of the active Transition.
--- @param name string name
--- @return boolean # True if name match the name of the active Transition.
function AnimatorTransitionInfo.IsName(name) end

--- ##### Method
--- ***
--- Does userName match the name of the active Transition.
--- @param userName string userName
--- @return boolean # True if userName match the name of the active Transition.
function AnimatorTransitionInfo.IsUserName(userName) end

--- ##### Type *AudioClip* inherits *Object*
--- ***
--- A container for audio data.  An AudioClip stores the audio file either compressed as ogg vorbis or uncompressed. AudioClips are referenced and used by AudioSources to play sounds.  Check out [Unity Audio Clip](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/AudioClip.html)
--- @class AudioClip
--- @field ambisonic boolean Returns true if this audio clip is ambisonic (read-only).
--- @field channels number The number of channels in the audio clip. (Read Only)
--- @field frequency number The sample frequency of the clip in Hertz. (Read Only)
--- @field length number The length of the audio clip in seconds. (Read Only)
--- @field loadInBackground boolean Corresponding to the "Load In Background" flag in the inspector, when this flag is set, the loading will happen delayed without blocking the main thread.
--- @field loadState AudioDataLoadState Returns the current load state of the audio data associated with an AudioClip.
--- @field loadType AudioClipLoadType The load type of the clip (read-only).
--- @field preloadAudioData boolean Preloads audio data of the clip when the clip asset is loaded. When this flag is off, scripts have to call AudioClip.LoadAudioData() to load the data before the clip can be played. Properties like length, channels and format are available before the audio data has been loaded.
--- @field samples number The length of the audio clip in samples. (Read Only)
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
AudioClip = {}

--- ##### Method
--- ***
--- Gets an array with sample data from the clip. 
--- @param offsetSamples number Offset to get samples. Note that it starts from 0.
--- @return boolean # Boolean stating if succesful. 
--- @return number[] #  An array with sample data from the clip.
function AudioClip.GetData(offsetSamples) end

--- ##### Method
--- ***
--- Loads the audio data of a clip. Clips that have "Preload Audio Data" set will load the audio data automatically.
--- @return boolean # Returns true if loading succeeded.
function AudioClip.LoadAudioData() end

--- ##### Method
--- ***
--- Set sample data in a clip.
--- @param data number[] sample data in a clip to be set.
--- @param offsetSamples number Use offsetSamples to write into a random position in the clip
--- @return boolean # boolean stating if the operation was succesful. 
function AudioClip.SetData(data, offsetSamples) end

--- ##### Method
--- ***
--- Unloads the audio data associated with the clip. This works only for AudioClips that are based on actual sound file assets.
--- @return boolean # bool Returns false if unloading failed.
function AudioClip.UnloadAudioData() end

--- ##### Method Inherited from *Object*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function AudioClip.GetInstanceID() end

--- ##### Static Method
--- ***
--- Creates a user AudioClip with a name and with the given length in samples, channels and frequency.
--- @param name string Name of clip.
--- @param lengthSamples number Number of sample frames.
--- @param channels number Number of channels per frame.
--- @param frequency number Sample frequency of clip.
--- @return AudioClip # AudioClip A reference to the created AudioClip.
function AudioClip:Create(name, lengthSamples, channels, frequency) end

--- ##### Type *AudioMixerGroup* inherits *Object*
--- ***
--- Object representing a group in the mixer.
--- @class AudioMixerGroup
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
AudioMixerGroup = {}

--- ##### Method Inherited from *Object*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function AudioMixerGroup.GetInstanceID() end

--- ##### Type *AudioSource* inherits *Behaviour*
--- ***
--- A representation of audio sources in 3D. Check out [Unity AudioSource](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/AudioSource.html)
--- @class AudioSource
--- @field bypassEffects boolean Bypass effects (Applied from filter components or global listener filters).
--- @field bypassListenerEffects boolean When set global effects on the AudioListener will not be applied to the audio signal generated by the AudioSource. Does not apply if the AudioSource is playing into a mixer group.
--- @field bypassReverbZones boolean When set doesn't route the signal from an AudioSource into the global reverb associated with reverb zones.
--- @field clip AudioClip The default AudioClip to play.
--- @field dopplerLevel number Sets the Doppler scale for this AudioSource.
--- @field ignoreListenerPause boolean Allows AudioSource to play even though AudioListener.pause is set to true. This is useful for the menu element sounds or background music in pause menus.
--- @field ignoreListenerVolume boolean This makes the audio source not take into account the volume of the audio listener.
--- @field isPlaying boolean Is the clip playing right now (Read Only)?
--- @field isVirtual boolean True if all sounds played by the AudioSource (main sound started by Play() or playOnAwake as well as one-shots) are culled by the audio system.
--- @field loop boolean Is the audio clip looping?
--- @field maxDistance number (Logarithmic rolloff) MaxDistance is the distance a sound stops attenuating at.<br>(Linear rolloff) MaxDistance is the distance where the sound is completely inaudible.
--- @field minDistance number Within the Min distance the AudioSource will cease to grow louder in volume.Outside the min distance the volume starts to attenuate.
--- @field mute boolean Un- / Mutes the AudioSource. Mute sets the volume=0, Un-Mute restore the original volume.
--- @field outputAudioMixerGroup AudioMixerGroup The target group to which the AudioSource should route its signal.
--- @field panStereo number Pans a playing sound in a stereo way (left or right). This only applies to sounds that are Mono or Stereo.
--- @field pitch number The pitch of the audio source.
--- @field playOnAwake boolean If set to true, the audio source will automatically start playing on awake.
--- @field priority number Sets the priority of the AudioSource.
--- @field reverbZoneMix number The amount by which the signal from the AudioSource will be mixed into the global reverb associated with the Reverb Zones.
--- @field rolloffMode AudioRolloffMode Sets/Gets how the AudioSource attenuates over distance.
--- @field spatialBlend number Sets how much this AudioSource is affected by 3D spatialisation calculations (attenuation, doppler etc). 0.0 makes the sound full 2D, 1.0 makes it full 3D.
--- @field spatialize boolean Enables or disables spatialization.
--- @field spatializePostEffects boolean Determines if the spatializer effect is inserted before or after the effect filters.
--- @field spread number Sets the spread angle (in degrees) of a 3d stereo or multichannel sound in speaker space.
--- @field time number Playback position in seconds.
--- @field velocityUpdateMode AudioVelocityUpdateMode Whether the Audio Source should be updated in the fixed or dynamic update.
--- @field volume number The volume of the audio source (0.0 to 1.0).
--- @field enabled boolean **Inherited**  |  Enabled Behaviours are Updated, disabled Behaviours are not.
--- @field isActiveAndEnabled boolean **Inherited**  |  Has the Behaviour had active and enabled called?
--- @field gameObject GameObject **Read-Only**  **Inherited**  |  The game object this component is attached to. A component is always attached to a game object.
--- @field tag string **Read-Only**  **Inherited**  |  The tag of this game object.
--- @field transform Transform **Read-Only**  **Inherited**  |  The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
AudioSource = {}

--- ##### Method
--- ***
--- Reads a user-defined parameter of a custom ambisonic decoder effect that is attached to an AudioSource.
--- @param index number Zero-based index of user-defined parameter to be read.
--- @return boolean # bool True, if the parameter could be read.
--- @return number # Return value of the user-defined parameter that is read.
function AudioSource.GetAmbisonicDecoderFloat(index) end

--- ##### Method
--- ***
--- Get the current custom curve for the given AudioSourceCurveType. <br> Note that if there is no curve set, or the corresponding curve type value setter has been set, a single key AnimationCurve will be returned corresponding to the current value. 
--- @param type AudioSourceCurveType The curve type to get.
--- @return AnimationCurve # The custom AnimationCurve corresponding to the given curve type.
function AudioSource.GetCustomCurve(type) end

--- ##### Method
--- ***
--- Provides a block of the currently playing source's output data. <br> The array given in the samples parameter will be filled with the requested data.
--- @param length number The length of the samples to be returned. Length must be a power of 2.
--- @param channel number The channel to sample from.
--- @return number[] # The array populated with audio samples
function AudioSource.GetOutputData(length, channel) end

--- ##### Method
--- ***
--- Reads a user-defined parameter of a custom spatializer effect that is attached to an AudioSource.
--- @param index number Zero-based index of user-defined parameter to be read.
--- @return boolean # True, if the parameter could be read.
--- @return number # Return value of the user-defined parameter that is read.
function AudioSource.GetSpatializerFloat(index) end

--- ##### Method
--- ***
--- Provides a block of the currently playing audio source's spectrum data. <br/> The array given in the samples parameter will be filled with the requested data.
--- @param Length number Length of the block of the Spectrum Data to be returned. Must be a power of 2.
--- @param channel number The channel to sample from.
--- @param window FFTWindow The FFTWindow type to use when sampling.
--- @return number[] # The array populated with audio samples.
function AudioSource.GetSpectrumData(Length, channel, window) end

--- ##### Method
--- ***
--- Pauses playing the clip.
function AudioSource.Pause() end

--- ##### Method
--- ***
--- Plays the clip.
function AudioSource.Play() end

--- ##### Method
--- ***
--- Plays the clip with a delay specified in seconds.
--- @param delay number Delay time specified in seconds.
function AudioSource.PlayDelayed(delay) end

--- ##### Method
--- ***
--- Plays an AudioClip, and scales the AudioSource volume by volumeScale.
--- @param clip AudioClip The clip being played.
--- @param volumeScale number? **Optional**(default = 0) The scale of the volume (0-1).
function AudioSource.PlayOneShot(clip, volumeScale) end

--- ##### Method
--- ***
--- Plays the clip at a specific time on the absolute time-line that AudioSettings.dspTime reads from.
--- @param time number Time in seconds on the absolute time-line that AudioSettings.dspTime refers to for when the sound should start playing.
function AudioSource.PlayScheduled(time) end

--- ##### Method
--- ***
--- Sets a user-defined parameter of a custom ambisonic decoder effect that is attached to an AudioSource.
--- @param index number Zero-based index of user-defined parameter to be set.
--- @param value number New value of the user-defined parameter.
--- @return boolean # True, if the parameter could be set.
function AudioSource.SetAmbisonicDecoderFloat(index, value) end

--- ##### Method
--- ***
--- Set the custom curve for the given AudioSourceCurveType.
--- @param type AudioSourceCurveType The curve type that should be set.
--- @param curve AnimationCurve The curve that should be applied to the given curve type.
function AudioSource.SetCustomCurve(type, curve) end

--- ##### Method
--- ***
--- Changes the time at which a sound that has already been scheduled to play will end. Notice that depending on the timing not all rescheduling requests can be fulfilled.
--- @param time number Time in seconds.
function AudioSource.SetScheduledEndTime(time) end

--- ##### Method
--- ***
--- Changes the time at which a sound that has already been scheduled to play will start.
--- @param time number Time in seconds.
function AudioSource.SetScheduledStartTime(time) end

--- ##### Method
--- ***
--- Sets a user-defined parameter of a custom spatializer effect that is attached to an AudioSource.
--- @param index number Zero-based index of user-defined parameter to be set.
--- @param value number New value of the user-defined parameter.
--- @return boolean # True, if the parameter could be set.
function AudioSource.SetSpatializerFloat(index, value) end

--- ##### Method
--- ***
--- Stops playing the clip.
function AudioSource.Stop() end

--- ##### Method
--- ***
--- Unpause the paused playback of this AudioSource.
function AudioSource.UnPause() end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Calls the method named methodName on every Lua Script in this game object or any of its children.
--- @param methodName string Name of the method to call.
--- @param parameter any? **Optional**(default = nil) Optional parameter to pass to the method (can be any value).
function AudioSource.BroadcastMessage(methodName, parameter) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function AudioSource.CompareTag(tag) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # Array of all Lua scripts that attached to the game object.
function AudioSource.GetAllLuaScripts() end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the component of Type type if the game object has one attached, nil if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # the component of Type type
function AudioSource.GetComponent(type) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function AudioSource.GetComponentInChildren(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function AudioSource.GetComponentInParent(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function AudioSource.GetComponents(type) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function AudioSource.GetComponentsInChildren(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function AudioSource.GetComponentsInParent(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Calls the method named methodName on every Lua Script in this game object. 
--- @param methodName string Name of the method to call.
--- @param value any? **Optional**(default = nil) Optional parameter for the method.
function AudioSource.SendMessage(methodName, value) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Calls the method named methodName on every LuaScript in this game object and on every ancestor of the behaviour.
--- @param methodName string Name of method to call.
--- @param value any? **Optional**(default = nil) Optional parameter value for the method.
function AudioSource.SendMessageUpwards(methodName, value) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of the component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or nil.
function AudioSource.TryGetComponent(type) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function AudioSource.GetInstanceID() end

--- ##### Static Method
--- ***
--- Plays an AudioClip at a given position in world space.
--- @param clip AudioClip Audio data to play.
--- @param position Vector3 Position in world space from which sound originates.
--- @param volume number? **Optional**(default = 1.0) Playback volume.
function AudioSource:PlayClipAtPoint(clip, position, volume) end

--- ##### Type *Avatar* inherits *Object*
--- ***
--- Avatar definition. [Unity Avatar](https://docs.unity3d.com/ScriptReference/Avatar.html)
--- @class Avatar
--- @field humanDescription HumanDescription Returns the HumanDescription used to create this Avatar.
--- @field isHuman boolean Return true if this avatar is a valid human avatar. (read-only)
--- @field isValid boolean Return true if this avatar is a valid mecanim avatar. It can be a generic avatar or a human avatar.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
Avatar = {}

--- ##### Method Inherited from *Object*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function Avatar.GetInstanceID() end

--- ##### Type *Behaviour* inherits *Component*
--- ***
--- Behaviours are Components that can be enabled or disabled.
--- @class Behaviour
--- @field enabled boolean Enabled Behaviours are Updated, disabled Behaviours are not.
--- @field isActiveAndEnabled boolean Has the Behaviour had active and enabled called?
--- @field gameObject GameObject **Read-Only**  **Inherited**  |  The game object this component is attached to. A component is always attached to a game object.
--- @field tag string **Read-Only**  **Inherited**  |  The tag of this game object.
--- @field transform Transform **Read-Only**  **Inherited**  |  The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
Behaviour = {}

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object or any of its children.
--- @param methodName string Name of the method to call.
--- @param parameter any? **Optional**(default = nil) Optional parameter to pass to the method (can be any value).
function Behaviour.BroadcastMessage(methodName, parameter) end

--- ##### Method Inherited from *Component*
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function Behaviour.CompareTag(tag) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # Array of all Lua scripts that attached to the game object.
function Behaviour.GetAllLuaScripts() end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type if the game object has one attached, nil if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # the component of Type type
function Behaviour.GetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function Behaviour.GetComponentInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function Behaviour.GetComponentInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function Behaviour.GetComponents(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function Behaviour.GetComponentsInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function Behaviour.GetComponentsInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object. 
--- @param methodName string Name of the method to call.
--- @param value any? **Optional**(default = nil) Optional parameter for the method.
function Behaviour.SendMessage(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every LuaScript in this game object and on every ancestor of the behaviour.
--- @param methodName string Name of method to call.
--- @param value any? **Optional**(default = nil) Optional parameter value for the method.
function Behaviour.SendMessageUpwards(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of the component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or nil.
function Behaviour.TryGetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function Behaviour.GetInstanceID() end

--- ##### Type *Bounds*
--- ***
--- Represents an axis aligned bounding box. [Unity Bounds](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/Bounds.html)
--- @class Bounds
--- @field center Vector3 The center of the bounding box.
--- @field extents Vector3 The extents of the Bounding Box. This is always half of the size of the Bounds.
--- @field max Vector3 The maximal point of the box. This is always equal to center+extents.
--- @field min Vector3 The minimal point of the box. This is always equal to center-extents.
--- @field size Vector3 The total size of the box. This is always twice as large as the extents.
Bounds = {}

--- ##### Constructor for *Bounds*
--- ***
--- Creates a new Bounds.
--- @param center Vector3 The location of the origin of the Bounds.
--- @param size Vector3 The dimensions of the Bounds.
--- @return Bounds
function Bounds(center, size) end

--- ##### Method
--- ***
--- The closest point on the bounding box.
--- @param point Vector3 Arbitrary point.
--- @return Vector3 # The point on the bounding box or inside the bounding box.
function Bounds.ClosestPoint(point) end

--- ##### Method
--- ***
--- Is point contained in the bounding box?
--- @param point Vector3 point
--- @return boolean # Is point contained in the bounding box?
function Bounds.Contains(point) end

--- ##### Method
--- ***
--- Grows the Bounds to include the point.
--- @param point Vector3 point
function Bounds.Encapsulate(point) end

--- ##### Method
--- ***
--- Grow the bounds to encapsulate the bounds.
--- @param bounds Bounds bounds
function Bounds.Encapsulate(bounds) end

--- ##### Method
--- ***
--- Expand the bounds by increasing its size by amount along each side.
--- @param amount number amount
function Bounds.Expand(amount) end

--- ##### Method
--- ***
--- Expand the bounds by increasing its size by amount along each side.
--- @param amount Vector3 
function Bounds.Expand(amount) end

--- ##### Method
--- ***
--- Does ray intersect this bounding box?
--- @param ray Ray ray
--- @return boolean # Does ray intersect this bounding box?
function Bounds.IntersectRay(ray) end

--- ##### Method
--- ***
--- Does another bounding box intersect with this bounding box?
--- @param bounds Bounds bounds
--- @return boolean # Does another bounding box intersect with this bounding box?
function Bounds.Intersects(bounds) end

--- ##### Method
--- ***
--- Sets the bounds to the min and max value of the box.
--- @param min Vector3 min
--- @param max Vector3 max
function Bounds.SetMinMax(min, max) end

--- ##### Method
--- ***
--- The smallest squared distance between the point and this bounding box.
--- @param point Bounds point
function Bounds.SqrDistance(point) end

--- ##### Type *BoxCollider* inherits *Collider*
--- ***
--- A box-shaped primitive collider. Unity [BoxCollider](https://docs.unity3d.com/2019.4/Documentation/ScriptReference/BoxCollider.html)
--- @class BoxCollider
--- @field center Vector3 The center of the box, measured in the object's local space.
--- @field size Vector3 The size of the box, measured in the object's local space.
--- @field attachedRigidbody Rigidbody **Inherited**  |  The rigidbody the collider is attached to.
--- @field bounds Bounds **Inherited**  |  The world space bounding volume of the collider (Read Only).
--- @field contactOffset number **Inherited**  |  Contact offset value of this collider.
--- @field enabled boolean **Inherited**  |  Enabled Colliders will collide with other Colliders, disabled Colliders won't.
--- @field isTrigger boolean **Inherited**  |  Is the collider a trigger?
--- @field material PhysicMaterial **Inherited**  |  The material used by the collider.
--- @field sharedMaterial PhysicMaterial **Inherited**  |  The shared physic material of this collider.
--- @field gameObject GameObject **Read-Only**  **Inherited**  |  The game object this component is attached to. A component is always attached to a game object.
--- @field tag string **Read-Only**  **Inherited**  |  The tag of this game object.
--- @field transform Transform **Read-Only**  **Inherited**  |  The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
BoxCollider = {}

--- ##### Method Inherited from *Collider*
--- ***
--- Returns a point on the collider that is closest to a given location.
--- @param position Vector3 Location you want to find the closest point to.
--- @return Vector3 # The point on the collider that is closest to the specified location.
function BoxCollider.ClosestPoint(position) end

--- ##### Method Inherited from *Collider*
--- ***
--- The closest point to the bounding box of the attached collider.
--- @param position Vector3 
--- @return Vector3 # closest point to the bounding box of the attached collider.
function BoxCollider.ClosestPointOnBounds(position) end

--- ##### Method Inherited from *Collider*
--- ***
--- Casts a Ray that ignores all Colliders except this one.
--- @param ray Ray The starting point and direction of the ray.
--- @param maxDistance number The max length of the ray.
--- @return boolean # True when the ray intersects the collider, otherwise false.
--- @return RaycastHit # If true is returned, hitInfo will contain more information about where the collider was hit.
function BoxCollider.Raycast(ray, maxDistance) end

--- ##### Method Inherited from *Collider*
--- ***
--- Calls the method named methodName on every Lua Script in this game object or any of its children.
--- @param methodName string Name of the method to call.
--- @param parameter any? **Optional**(default = nil) Optional parameter to pass to the method (can be any value).
function BoxCollider.BroadcastMessage(methodName, parameter) end

--- ##### Method Inherited from *Collider*
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function BoxCollider.CompareTag(tag) end

--- ##### Method Inherited from *Collider*
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # Array of all Lua scripts that attached to the game object.
function BoxCollider.GetAllLuaScripts() end

--- ##### Method Inherited from *Collider*
--- ***
--- Returns the component of Type type if the game object has one attached, nil if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # the component of Type type
function BoxCollider.GetComponent(type) end

--- ##### Method Inherited from *Collider*
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function BoxCollider.GetComponentInChildren(t) end

--- ##### Method Inherited from *Collider*
--- ***
--- Returns the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function BoxCollider.GetComponentInParent(t) end

--- ##### Method Inherited from *Collider*
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function BoxCollider.GetComponents(type) end

--- ##### Method Inherited from *Collider*
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function BoxCollider.GetComponentsInChildren(t) end

--- ##### Method Inherited from *Collider*
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function BoxCollider.GetComponentsInParent(t) end

--- ##### Method Inherited from *Collider*
--- ***
--- Calls the method named methodName on every Lua Script in this game object. 
--- @param methodName string Name of the method to call.
--- @param value any? **Optional**(default = nil) Optional parameter for the method.
function BoxCollider.SendMessage(methodName, value) end

--- ##### Method Inherited from *Collider*
--- ***
--- Calls the method named methodName on every LuaScript in this game object and on every ancestor of the behaviour.
--- @param methodName string Name of method to call.
--- @param value any? **Optional**(default = nil) Optional parameter value for the method.
function BoxCollider.SendMessageUpwards(methodName, value) end

--- ##### Method Inherited from *Collider*
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of the component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or nil.
function BoxCollider.TryGetComponent(type) end

--- ##### Method Inherited from *Collider*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function BoxCollider.GetInstanceID() end

--- ##### Type *CapsuleCollider* inherits *Collider*
--- ***
--- A capsule-shaped primitive collider.
--- @class CapsuleCollider
--- @field center Vector3 The center of the capsule, measured in the object's local space.
--- @field direction number The direction of the capsule.
--- @field height number The height of the capsule measured in the object's local space.
--- @field radius number The radius of the sphere, measured in the object's local space.
--- @field attachedRigidbody Rigidbody **Inherited**  |  The rigidbody the collider is attached to.
--- @field bounds Bounds **Inherited**  |  The world space bounding volume of the collider (Read Only).
--- @field contactOffset number **Inherited**  |  Contact offset value of this collider.
--- @field enabled boolean **Inherited**  |  Enabled Colliders will collide with other Colliders, disabled Colliders won't.
--- @field isTrigger boolean **Inherited**  |  Is the collider a trigger?
--- @field material PhysicMaterial **Inherited**  |  The material used by the collider.
--- @field sharedMaterial PhysicMaterial **Inherited**  |  The shared physic material of this collider.
--- @field gameObject GameObject **Read-Only**  **Inherited**  |  The game object this component is attached to. A component is always attached to a game object.
--- @field tag string **Read-Only**  **Inherited**  |  The tag of this game object.
--- @field transform Transform **Read-Only**  **Inherited**  |  The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
CapsuleCollider = {}

--- ##### Method Inherited from *Collider*
--- ***
--- Returns a point on the collider that is closest to a given location.
--- @param position Vector3 Location you want to find the closest point to.
--- @return Vector3 # The point on the collider that is closest to the specified location.
function CapsuleCollider.ClosestPoint(position) end

--- ##### Method Inherited from *Collider*
--- ***
--- The closest point to the bounding box of the attached collider.
--- @param position Vector3 
--- @return Vector3 # closest point to the bounding box of the attached collider.
function CapsuleCollider.ClosestPointOnBounds(position) end

--- ##### Method Inherited from *Collider*
--- ***
--- Casts a Ray that ignores all Colliders except this one.
--- @param ray Ray The starting point and direction of the ray.
--- @param maxDistance number The max length of the ray.
--- @return boolean # True when the ray intersects the collider, otherwise false.
--- @return RaycastHit # If true is returned, hitInfo will contain more information about where the collider was hit.
function CapsuleCollider.Raycast(ray, maxDistance) end

--- ##### Method Inherited from *Collider*
--- ***
--- Calls the method named methodName on every Lua Script in this game object or any of its children.
--- @param methodName string Name of the method to call.
--- @param parameter any? **Optional**(default = nil) Optional parameter to pass to the method (can be any value).
function CapsuleCollider.BroadcastMessage(methodName, parameter) end

--- ##### Method Inherited from *Collider*
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function CapsuleCollider.CompareTag(tag) end

--- ##### Method Inherited from *Collider*
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # Array of all Lua scripts that attached to the game object.
function CapsuleCollider.GetAllLuaScripts() end

--- ##### Method Inherited from *Collider*
--- ***
--- Returns the component of Type type if the game object has one attached, nil if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # the component of Type type
function CapsuleCollider.GetComponent(type) end

--- ##### Method Inherited from *Collider*
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function CapsuleCollider.GetComponentInChildren(t) end

--- ##### Method Inherited from *Collider*
--- ***
--- Returns the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function CapsuleCollider.GetComponentInParent(t) end

--- ##### Method Inherited from *Collider*
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function CapsuleCollider.GetComponents(type) end

--- ##### Method Inherited from *Collider*
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function CapsuleCollider.GetComponentsInChildren(t) end

--- ##### Method Inherited from *Collider*
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function CapsuleCollider.GetComponentsInParent(t) end

--- ##### Method Inherited from *Collider*
--- ***
--- Calls the method named methodName on every Lua Script in this game object. 
--- @param methodName string Name of the method to call.
--- @param value any? **Optional**(default = nil) Optional parameter for the method.
function CapsuleCollider.SendMessage(methodName, value) end

--- ##### Method Inherited from *Collider*
--- ***
--- Calls the method named methodName on every LuaScript in this game object and on every ancestor of the behaviour.
--- @param methodName string Name of method to call.
--- @param value any? **Optional**(default = nil) Optional parameter value for the method.
function CapsuleCollider.SendMessageUpwards(methodName, value) end

--- ##### Method Inherited from *Collider*
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of the component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or nil.
function CapsuleCollider.TryGetComponent(type) end

--- ##### Method Inherited from *Collider*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function CapsuleCollider.GetInstanceID() end

--- ##### Type *CloudVariableBank*
--- ***
--- Stores cloud variables. The variable banks are assigned to hold cloud variables belonging to specific subjects such as User, World and Server. 
--- @class CloudVariableBank
--- @field [key] any Gets or sets the cloud variable by Key.
--- @field ReadOnly boolean **Read-Only**  |  Specifies if this variable bank is designated as read-only. Writing variables (Creating, Updating, deleting) of read-only variable banks is not allowed. 
CloudVariableBank = {}

--- ##### Method
--- ***
--- Returns value assigned to a key. It throws an error if the key does not exist.
--- @param key string The key associated with the variable.
--- @return any # The value assigned to the key.
function CloudVariableBank.GetVariable(key) end

--- ##### Method
--- ***
--- Check if a key exists.
--- @param key string The key to check.  
--- @return boolean # True if the key exists.
function CloudVariableBank.KeyExists(key) end

--- ##### Method
--- ***
--- Marks the key to be deleted from the server. Same result can be accomplished by setting the value of the key to nil.
--- @param key string The key to associate the value to. 
function CloudVariableBank.MarkKeyForDeletion(key) end

--- ##### Method
--- ***
--- Creates a cloud variable with specified key and value. If the key already exists, it updates its value. 
--- @param key string The key to associate the value to. 
--- @param value any The value of this variable. 
function CloudVariableBank.SetVariable(key, value) end

--- ##### Type *CloudVariables*
--- ***
--- Provides access to Cloud Variables. You can use cloud variables to store persistent information about the user. Generally, the values pushed to cloud variable are stored in the server. In local mode, variables are stored locally. 
--- @class CloudVariables
--- @field IsEnabled boolean **Static**  **Read-Only**  |  Is use of cloud variables enabled for this world? 
--- @field ServerVariables CloudVariableBank **Static**  **Read-Only**  |  The variable bank which belongs to the current server. Most of the time world level cloud variables are read-only unless the current user is server admin.  
--- @field UserVariables CloudVariableBank **Static**  **Read-Only**  |  The variable bank belonging to the current local user. 
--- @field WorldVariables CloudVariableBank **Static**  **Read-Only**  |  The variable bank belongs to the current world. Most of the time world level cloud variables are read-only unless the current user is world creator.
CloudVariables = {}

--- ##### Static Method
--- ***
--- Get score board associated with a variable name. The score board is generated based on previously assigned variables to users. A user with an assigned variable matching the name provided included in the score board if the variable type is number. You can specify where and how much of scoreboard to retrieve by assigning skip and limit parameters. 
--- @param variableName string Name of the variable to retrieve the scoreboard.  
--- @param descending boolean? **Optional**(default = true) Get the scoreboard with higher values first.
--- @param skip number? **Optional**(default = 0) Number of scores to skip at the beginning before returning the scoreboard. 
--- @param limit number? **Optional**(default = INF) Limit how many scores to be returned.
--- @return Promise # A promise which resolves to an array of `ScoreBoardEntry`
function CloudVariables:GetScoreBoard(variableName, descending, skip, limit) end

--- ##### Static Method
--- ***
--- Returns the summary about a variable that assigned to the specified subject. The summary is generated by going through all the variables instances assigned to the subject and collecting summary information. An example of summary usage is to get the total number of golds being distributed to users in server, given that the multiple worlds in the server can give gold to player for various reasons. 
--- @param variableName string The name of the variable to create summary from. 
--- @param subject VariableSubject The subject in which the summary is collected from. 
--- @return Promise # A promise which resolves to a `CloudVariableSummary` object.
function CloudVariables:GetUserVariableSummary(variableName, subject) end

--- ##### Static Method
--- ***
--- Create a request for client to publish the variable changes to the server as soon as possible. 
function CloudVariables:RequestToPublish() end

--- ##### Type *CloudVariableSummary*
--- ***
--- Object containing summary information about a cloud variable.
--- @class CloudVariableSummary
--- @field Count number **Read-Only**  |  The count of variables with the same name.
--- @field NumAvg number **Read-Only**  |  Average of the variables if their type was number.
--- @field NumMax number **Read-Only**  |  Maximum of the variables if their type was number.
--- @field NumMin number **Read-Only**  |  Minimum of the variables if their type was number.
--- @field NumSum number **Read-Only**  |  Sum of the variables if their type was number.
--- @field StringMax string **Read-Only**  |  Maximum of the variables if their type was string. 
--- @field StringMin string **Read-Only**  |  Minimum of the variables if their type was string. 
--- @field VariableName string **Read-Only**  |  The name of the variable.
CloudVariableSummary = {}

--- ##### Type *Collider* inherits *Component*
--- ***
--- A base class of all colliders. [Unity Collider](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/Collider.html)
--- @class Collider
--- @field attachedRigidbody Rigidbody The rigidbody the collider is attached to.
--- @field bounds Bounds The world space bounding volume of the collider (Read Only).
--- @field contactOffset number Contact offset value of this collider.
--- @field enabled boolean Enabled Colliders will collide with other Colliders, disabled Colliders won't.
--- @field isTrigger boolean Is the collider a trigger?
--- @field material PhysicMaterial The material used by the collider.
--- @field sharedMaterial PhysicMaterial The shared physic material of this collider.
--- @field gameObject GameObject **Read-Only**  **Inherited**  |  The game object this component is attached to. A component is always attached to a game object.
--- @field tag string **Read-Only**  **Inherited**  |  The tag of this game object.
--- @field transform Transform **Read-Only**  **Inherited**  |  The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
Collider = {}

--- ##### Method
--- ***
--- Returns a point on the collider that is closest to a given location.
--- @param position Vector3 Location you want to find the closest point to.
--- @return Vector3 # The point on the collider that is closest to the specified location.
function Collider.ClosestPoint(position) end

--- ##### Method
--- ***
--- The closest point to the bounding box of the attached collider.
--- @param position Vector3 
--- @return Vector3 # closest point to the bounding box of the attached collider.
function Collider.ClosestPointOnBounds(position) end

--- ##### Method
--- ***
--- Casts a Ray that ignores all Colliders except this one.
--- @param ray Ray The starting point and direction of the ray.
--- @param maxDistance number The max length of the ray.
--- @return boolean # True when the ray intersects the collider, otherwise false.
--- @return RaycastHit # If true is returned, hitInfo will contain more information about where the collider was hit.
function Collider.Raycast(ray, maxDistance) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object or any of its children.
--- @param methodName string Name of the method to call.
--- @param parameter any? **Optional**(default = nil) Optional parameter to pass to the method (can be any value).
function Collider.BroadcastMessage(methodName, parameter) end

--- ##### Method Inherited from *Component*
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function Collider.CompareTag(tag) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # Array of all Lua scripts that attached to the game object.
function Collider.GetAllLuaScripts() end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type if the game object has one attached, nil if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # the component of Type type
function Collider.GetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function Collider.GetComponentInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function Collider.GetComponentInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function Collider.GetComponents(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function Collider.GetComponentsInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function Collider.GetComponentsInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object. 
--- @param methodName string Name of the method to call.
--- @param value any? **Optional**(default = nil) Optional parameter for the method.
function Collider.SendMessage(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every LuaScript in this game object and on every ancestor of the behaviour.
--- @param methodName string Name of method to call.
--- @param value any? **Optional**(default = nil) Optional parameter value for the method.
function Collider.SendMessageUpwards(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of the component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or nil.
function Collider.TryGetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function Collider.GetInstanceID() end

--- ##### Type *Collision*
--- ***
--- Describes a collision. [Unity Collision](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/Collision.html)
--- @class Collision
--- @field collider Collider The Collider we hit (Read Only).
--- @field contactCount number Gets the number of contacts for this collision.
--- @field contacts ContactPoint[] The contact points generated by the physics engine. You should avoid using this as it produces memory garbage. Use GetContact or GetContacts instead.
--- @field gameObject GameObject The GameObject whose collider you are colliding with. (Read Only).
--- @field impulse Vector3 The total impulse applied to this contact pair to resolve the collision.
--- @field relativeVelocity Vector3 The relative linear velocity of the two colliding objects (Read Only).
--- @field rigidbody Rigidbody The Rigidbody we hit (Read Only). This is nil if the object we hit is a collider with no rigidbody attached.
--- @field transform Transform The Transform of the object we hit (Read Only).
Collision = {}

--- ##### Method
--- ***
--- Gets the contact point at the specified index.
--- @param index number The index of the contact to retrieve.
--- @return ContactPoint # The contact at the specified index.
function Collision.GetContact(index) end

--- ##### Type *Color*
--- ***
--- Representation of RGBA colors.
--- @class Color
--- @field a number Alpha component of the color (0 is transparent, 1 is opaque).
--- @field b number Blue component of the color.
--- @field black Color **Static**  **Read-Only**  |  Solid black. RGBA is (0, 0, 0, 1).
--- @field blue Color **Static**  **Read-Only**  |  Solid blue. RGBA is (0, 0, 1, 1).
--- @field clear Color **Static**  **Read-Only**  |  Completely transparent. RGBA is (0, 0, 0, 0).
--- @field cyan Color **Static**  **Read-Only**  |  Cyan. RGBA is (0, 1, 1, 1).
--- @field g number Green component of the color.
--- @field gamma Color A version of the color that has had the gamma curve applied.
--- @field gray Color **Static**  **Read-Only**  |  Gray. RGBA is (0.5, 0.5, 0.5, 1).
--- @field grayscale number **Read-Only**  |  The grayscale value of the color. (Read Only)
--- @field green Color **Static**  **Read-Only**  |  Solid green. RGBA is (0, 1, 0, 1).
--- @field linear Color A linear value of an sRGB color.
--- @field magenta Color **Static**  **Read-Only**  |  Magenta. RGBA is (1, 0, 1, 1).
--- @field maxColorComponent number Returns the maximum color component value: Max(r,g,b).
--- @field r number Red component of the color.
--- @field red Color **Static**  **Read-Only**  |  Solid red. RGBA is (1, 0, 0, 1).
--- @field white Color **Static**  **Read-Only**  |  Solid white. RGBA is (1, 1, 1, 1).
--- @field yellow Color **Static**  **Read-Only**  |  Yellow. RGBA is (1, 0.92, 0.016, 1), but the color is nice to look at!
--- @operator sub(Color) : Color # Subtracts color `lhs` from color `rhs`. Each component is subtracted separately.
--- @operator mul(Color) : Color # Multiplies two colors together. Each component is multiplied separately.
--- @operator mul(number) : Color # Multiplies color `lhs` by the number `rhs`. Each color component is scaled separately.
--- @operator div(number) : Color # Divides color `lhs` by the number `rhs`. Each color component is scaled separately.
--- @operator add(Color) : Color # Adds two colors together. Each component is added separately.
Color = {}

--- ##### Constructor for *Color*
--- ***
--- Constructs a new Color with given r,g,b,a components.
--- @param r number Red component.
--- @param g number Green component.
--- @param b number Blue component.
--- @param a number? **Optional**(default = 1.0) Alpha component.
--- @return Color
function Color(r, g, b, a) end

--- ##### Static Method
--- ***
--- Creates an RGB colour from HSV input.
--- @param H number Hue [0..1].
--- @param S number Saturation [0..1].
--- @param V number Brightness value [0..1].
--- @return Color # An opaque colour with HSV matching the input.
function Color:HSVToRGB(H, S, V) end

--- ##### Static Method
--- ***
--- Creates an RGB color from the hue, saturation and value of the input.
--- @param H number Hue [0..1].
--- @param S number Saturation [0..1].
--- @param V number Brightness value [0..1].
--- @param hdr boolean Output HDR colours. If true, the returned colour will not be clamped to [0..1].
--- @return Color # An opaque colour with HSV matching the input.
function Color:HSVToRGB(H, S, V, hdr) end

--- ##### Static Method
--- ***
--- Linearly interpolates between colors a and b by t.
--- @param a Color Color a.
--- @param b Color Color b.
--- @param t number Float for combining a and b.
--- @return Color # interpolated color
function Color:Lerp(a, b, t) end

--- ##### Static Method
--- ***
--- Linearly interpolates between colors a and b by t.
--- @param a Color Color a
--- @param b Color Color b
--- @param t  number number t
--- @return Color # interpolated Color
function Color:LerpUnclamped(a, b, t ) end

--- ##### Static Method
--- ***
--- Calculates the hue, saturation and value of an RGB input color.
--- @param rgbColor Color An input color.
--- @return number # Output variable for hue (H).
--- @return number # Output variable for saturation (S).
--- @return number # Output variable for value (V).
function Color:RGBToHSV(rgbColor) end

--- ##### Type *Component* inherits *Object*
--- ***
--- Base class for everything attached to GameObjects. [Unity Component](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/Component.html)
--- @class Component
--- @field gameObject GameObject **Read-Only**  |  The game object this component is attached to. A component is always attached to a game object.
--- @field tag string **Read-Only**  |  The tag of this game object.
--- @field transform Transform **Read-Only**  |  The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
Component = {}

--- ##### Method
--- ***
--- Calls the method named methodName on every Lua Script in this game object or any of its children.
--- @param methodName string Name of the method to call.
--- @param parameter any? **Optional**(default = nil) Optional parameter to pass to the method (can be any value).
function Component.BroadcastMessage(methodName, parameter) end

--- ##### Method
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function Component.CompareTag(tag) end

--- ##### Method
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # Array of all Lua scripts that attached to the game object.
function Component.GetAllLuaScripts() end

--- ##### Method
--- ***
--- Returns the component of Type type if the game object has one attached, nil if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # the component of Type type
function Component.GetComponent(type) end

--- ##### Method
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function Component.GetComponentInChildren(t) end

--- ##### Method
--- ***
--- Returns the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function Component.GetComponentInParent(t) end

--- ##### Method
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function Component.GetComponents(type) end

--- ##### Method
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function Component.GetComponentsInChildren(t) end

--- ##### Method
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function Component.GetComponentsInParent(t) end

--- ##### Method
--- ***
--- Calls the method named methodName on every Lua Script in this game object. 
--- @param methodName string Name of the method to call.
--- @param value any? **Optional**(default = nil) Optional parameter for the method.
function Component.SendMessage(methodName, value) end

--- ##### Method
--- ***
--- Calls the method named methodName on every LuaScript in this game object and on every ancestor of the behaviour.
--- @param methodName string Name of method to call.
--- @param value any? **Optional**(default = nil) Optional parameter value for the method.
function Component.SendMessageUpwards(methodName, value) end

--- ##### Method
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of the component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or nil.
function Component.TryGetComponent(type) end

--- ##### Method Inherited from *Object*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function Component.GetInstanceID() end

--- ##### Type *ContactPoint*
--- ***
--- Describes a contact point where the collision occurs. [Unity ContactPoint](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/ContactPoint.html)
--- @class ContactPoint
--- @field normal Vector3 Normal of the contact point.
--- @field otherCollider Collider The other collider in contact at the point.
--- @field point Vector3 The point of contact.
--- @field separation number The distance between the colliders at the contact point.
--- @field thisCollider Collider The first collider in contact at the point.
ContactPoint = {}

--- ##### Type *Coroutine*
--- ***
--- nstances of this class are used to reference coroutines started by LuaBehaviour.StartCoroutine()
--- @class Coroutine
--- @field IsRunning boolean **Read-Only**  |  Is the coroutine is currently running?
Coroutine = {}

--- ##### Type *CoroutineTools*
--- ***
--- A class containing helper methods for working with coroutines.
--- @class CoroutineTools
CoroutineTools = {}

--- ##### Static Method
--- ***
--- When used inside a coroutine function, suspends the coroutine execution for the given amount of seconds.
--- @param seconds number The amounts of seconds to suspend the coroutine.
function CoroutineTools:WaitForSeconds(seconds) end

--- ##### Static Method
--- ***
--- Suspends the coroutine execution until the supplied function evaluates to true.
--- @param controlFunc function The Control function. The coroutine suspended until this function returns true.
--- @param _params ... Zero or more values to be passed to the control function. 
function CoroutineTools:WaitUntil(controlFunc, ...) end

--- ##### Type *Debug*
--- ***
--- The debugging tool for Lua scripts.
--- ##### example
--- * The Debug outputs a STDOUT. This is not visible to players in the Massive Loop client.
--- * When running the world in local test, The Debug output will be routed and showed in the Unity Editor with Massive Loop SDK package using the InterLog.
--- * When running the world in a normal Massive Loop client, the logs will be recorded on a normal game log file.
--- ```
--- -- log a normal message
--- Debug.Log("This is a message");
--- 
--- -- log a warning
--- Debug.LogWarning("Warning!");
--- ```
--- @class Debug
Debug = {}

--- ##### Static Method
--- ***
--- Simply logs a string passed in `message`.
--- @param message any The string to be logged.
function Debug:Log(message) end

--- ##### Static Method
--- ***
--- Logs the string passed by `message` as Error.
--- @param message any The string to be logged.
function Debug:LogError(message) end

--- ##### Static Method
--- ***
--- Logs the string passed by `message` as warning.
--- @param message any The string to be logged.
function Debug:LogWarning(message) end

--- ##### Type *EventHandler*
--- ***
--- A simple event handler utility. You can attach your functions as Listeners to an event. This meant to provide a simple interface with events in unity. Also, it can be used to create and handle custom events. The `EventHandler` instance can be used as a variable and passed around.  
--- @class EventHandler
--- @field count number **Read-Only**  |  The number of the handlers that attached to this event handler instance.
EventHandler = {}

--- ##### Constructor for *EventHandler*
--- ***
--- 
--- @return EventHandler
function EventHandler() end

--- ##### Method
--- ***
--- Adds a new function as a handler. The value must be a function type to properly attach it.
--- @param _function function The function which will called when event invoked 
function EventHandler.Add(_function) end

--- ##### Method
--- ***
--- Invokes the event. This calls all the functions that attached to this event. 
--- @param parameters ...? **Optional**(default = nil) Optional 
function EventHandler.Invoke(...) end

--- ##### Method
--- ***
--- Removes all the event listeners (functions) attached to this event.
function EventHandler.RemoveAllListeners() end

--- ##### Type *Flare* inherits *Object*
--- ***
--- A flare asset. Read more about flares in the [components reference.](https://docs.unity3d.com/2019.3/Documentation/Manual/class-Flare.html)<br> The flare class has no properties. It needs to be setup up in the inspector. You can reference flares and assign them to a Light at runtime.
--- @class Flare
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
Flare = {}

--- ##### Method Inherited from *Object*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function Flare.GetInstanceID() end

--- ##### Type *FrustumPlanes*
--- ***
--- This type contains the view space coordinates of the near projection plane. <br> [Unity FrustumPlanes](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/FrustumPlanes.html)
--- @class FrustumPlanes
--- @field bottom number Position in view space of the bottom side of the near projection plane.
--- @field left number Position in view space of the left side of the near projection plane.
--- @field right number Position in view space of the right side of the near projection plane.
--- @field top number Position in view space of the top side of the near projection plane. 
--- @field zFar number Z distance from the origin of view space to the far projection plane.
--- @field zNear number Z distance from the origin of view space to the near projection plane.
FrustumPlanes = {}

--- ##### Constructor for *FrustumPlanes*
--- ***
--- Creates new FrustumPlanes
--- @return FrustumPlanes
function FrustumPlanes() end

--- ##### Type *GameObject* inherits *Object*
--- ***
--- Base class for all entities in Unity Scenes. [Unity GameObject](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/GameObject.html)
--- @class GameObject
--- @field activeInHierarchy boolean Defines whether the GameObject is active in the Scene.
--- @field activeSelf boolean **Read-Only**  |  The local active state of this GameObject. (Read Only)
--- @field isStatic boolean Gets and sets the GameObject's StaticEditorFlags.
--- @field layer number The layer the game object is in.
--- @field Owner MLPlayer Current Network owner of this game object. Network ownership allows a certain client to modify properties of a game object if that game object or any of its parent or grand parents are synchronized using MLSynchronizer. Nil of the object is not own by any player.
--- @field scene Scene Scene that the GameObject is part of.
--- @field tag string The tag of this game object.
--- @field transform Transform The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
GameObject = {}

--- ##### Constructor for *GameObject*
--- ***
--- Creates a new game object.
--- @return GameObject
function GameObject() end

--- ##### Method
--- ***
--- Adds a component class of type componentType to the game object.
--- @generic TComponent
--- @param componentType TComponent component type
--- @return TComponent # Added Component
function GameObject.AddComponent(componentType) end

--- ##### Method
--- ***
--- Calls the method named methodName on every lua script in this game object or any of its children.
--- @param methodName string method Name
--- @param parameter any? **Optional**(default = nil) optional parameter
function GameObject.BroadcastMessage(methodName, parameter) end

--- ##### Method
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function GameObject.CompareTag(tag) end

--- ##### Method
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # array of all Lua scripts that attached to the game object.
function GameObject.GetAllLuaScripts() end

--- ##### Method
--- ***
--- Returns the component of Type type if the game object has one attached, null if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # component of Type
function GameObject.GetComponent(type) end

--- ##### Method
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function GameObject.GetComponentInChildren(type) end

--- ##### Method
--- ***
--- Retrieves the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param type TComponent Type of component to find.
--- @return TComponent # Returns a component if a component matching the type is found. Returns nil otherwise.
function GameObject.GetComponentInParent(type) end

--- ##### Method
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function GameObject.GetComponents(type) end

--- ##### Method
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function GameObject.GetComponentsInChildren(type) end

--- ##### Method
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function GameObject.GetComponentsInParent(type) end

--- ##### Method
--- ***
--- Returns a MLPlayer object if this object or any of its ancestors is a ML Player. Null Otherwise.  
--- @return MLPlayer # MLPlayer object if this object or any of its ancestors is a ML Player
function GameObject.GetPlayer() end

--- ##### Method
--- ***
--- Returns true if this object or any of the ancestors of this object is a ML player. 
--- @return boolean # true if this object or any of the ancestors of this object is a ML player. 
function GameObject.IsPlayer() end

--- ##### Method
--- ***
--- Transfers the Network ownership of this object to current client (the client called this method). Network ownership allows a certain client to modify properties of a game object if that game object or any of its parent or grandparents are synchronized using MLSynchronizer. 
function GameObject.RequestOwnership() end

--- ##### Method
--- ***
--- Calls the method named methodName on every lua script in this game object.
--- @param methodName string The name of the method to call.
--- @param value any? **Optional**(default = nil) An optional parameter value to pass to the called method.
function GameObject.SendMessage(methodName, value) end

--- ##### Method
--- ***
--- Calls the method named methodName on every MonoBehaviour in this game object and on every ancestor of the behaviour.
--- @param methodName string The name of the method to call.
--- @param value any? **Optional**(default = nil) An optional parameter value to pass to the called method.
function GameObject.SendMessageUpwards(methodName, value) end

--- ##### Method
--- ***
--- Activates/Deactivates the GameObject, depending on the given true or false value.
--- @param value boolean Activate or deactivate the object, where true activates the GameObject and false deactivates the GameObject.
function GameObject.SetActive(value) end

--- ##### Method
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or null.
function GameObject.TryGetComponent(type) end

--- ##### Method Inherited from *Object*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function GameObject.GetInstanceID() end

--- ##### Static Method
--- ***
--- Creates a game object with a primitive mesh renderer and appropriate collider.
--- @param type PrimitiveType The type of primitive object to create.
--- @return GameObject # created game object
function GameObject:CreatePrimitive(type) end

--- ##### Static Method
--- ***
--- Finds a GameObject by name and returns it.
--- @param name string name of gameObject to find
--- @return GameObject # gameObject
function GameObject:Find(name) end

--- ##### Static Method
--- ***
--- Returns an array of active GameObjects tagged tag. Returns empty array if no GameObject was found.
--- @param tag string The name of the tag to search GameObjects for.
--- @return GameObject[] # GameObjects
function GameObject:FindGameObjectsWithTag(tag) end

--- ##### Type *HandInput*
--- ***
--- Handles the captured input from grabbed object. The input binds to following keys, depending on client mode and hand:  VR Mode Left Hand: left joystick as Range and left joystick button as click  VR Mode Right Hand: right joystick as Range and right joystick button as click  Desktop Mode Left Hand: WASD as range and L_Shift as click  Desktop Mode Right Hand: Arrows as range and R_Shift as click
--- @class HandInput
--- @field Click boolean **Read-Only**  |  True if Joystick (VR Mode) or L_Shift (Desktop Mode Left Hand) or R_Shift (Desktop Mode Right Hand) is clicked
--- @field Range Vector2 **Read-Only**  |  Joystick (VR Mode) or WASD (Desktop Mode Left Hand) or Up Down,Left,Right (Desktop Mode Right Hand) values  
HandInput = {}

--- ##### Type *HumanBone*
--- ***
--- The mapping between a bone in the model and the conceptual bone in the Mecanim human anatomy. This is the Lua implmentaion of Unity [HumanBone](https://docs.unity3d.com/ScriptReference/HumanBone.html)
--- @class HumanBone
--- @field boneName string The name of the bone to which the Mecanim human bone is mapped. 
--- @field humanName string The name of the Mecanim human bone to which the bone from the model is mapped.
--- @field limit HumanLimit The rotation limits that define the muscle for this bone.
HumanBone = {}

--- ##### Constructor for *HumanBone*
--- ***
--- Creates new HumanBone
--- @return HumanBone
function HumanBone() end

--- ##### Type *HumanDescription*
--- ***
--- Class that holds humanoid avatar parameters
--- @class HumanDescription
--- @field armStretch number Amount by which the arm's length is allowed to stretch when using IK.
--- @field feetSpacing number Modification to the minimum distance between the feet of a humanoid model.
--- @field hasTranslationDoF boolean True for any human that has a translation Degree of Freedom (DoF). It is set to false by default. Translation DoF are on Spine, Chest, Neck, Shoulder and Upper Leg bones.
--- @field human HumanBone[] Mapping between Mecanim bone names and bone names in the rig.
--- @field legStretch number Amount by which the leg's length is allowed to stretch when using IK.
--- @field lowerArmTwist number Defines how the lower arm's roll/twisting is distributed between the elbow and wrist joints.
--- @field lowerLegTwist number Defines how the lower leg's roll/twisting is distributed between the knee and ankle.
--- @field skeleton SkeletonBone[] List of bone Transforms to include in the model.
--- @field upperArmTwist number Defines how the upper arm's roll/twisting is distributed between the shoulder and elbow joints.
--- @field upperLegTwist number Defines how the upper leg's roll/twisting is distributed between the thigh and knee joints.
HumanDescription = {}

--- ##### Constructor for *HumanDescription*
--- ***
--- Creates new HumanDescription
--- @return HumanDescription
function HumanDescription() end

--- ##### Type *HumanLimit*
--- ***
--- This class stores the rotation limits that define the muscle for a single human bone. [Unity HumanLimit](https://docs.unity3d.com/ScriptReference/HumanLimit.html)
--- @class HumanLimit
--- @field axisLength number Length of the bone to which the limit is applied.
--- @field center Vector3 The default orientation of a bone when no muscle action is applied.
--- @field max Vector3 The maximum rotation away from the initial value that this muscle can apply.
--- @field min Vector3 The maximum negative rotation away from the initial value that this muscle can apply.
--- @field useDefaultValues boolean Should this limit use the default values?
HumanLimit = {}

--- ##### Constructor for *HumanLimit*
--- ***
--- Creates new HumanLimit
--- @return HumanLimit
function HumanLimit() end

--- ##### Type *JointSpring*
--- ***
--- JointSpring is used add a spring force to HingeJoint and PhysicMaterial.
--- @class JointSpring
--- @field damper number The damper force uses to dampen the spring.
--- @field spring number The spring forces used to reach the target position.
--- @field targetPosition number The target position the joint attempts to reach.
JointSpring = {}

--- ##### Type *Keyframe*
--- ***
--- A single keyframe that can be injected into an animation curve.
--- @class Keyframe
--- @field inTangent number Sets the incoming tangent for this key. The incoming tangent affects the slope of the curve from the previous key to this key.
--- @field inWeight number Sets the incoming weight for this key. The incoming weight affects the slope of the curve from the previous key to this key.
--- @field outTangent number Sets the outgoing tangent for this key. The outgoing tangent affects the slope of the curve from this key to the next key.
--- @field outWeight number Sets the outgoing weight for this key. The outgoing weight affects the slope of the curve from this key to the next key.
--- @field time number The time of the keyframe. <br> In a 2D graph you could think of this as the x-value.
--- @field weightedMode WeightedMode Weighted mode for the keyframe.
Keyframe = {}

--- ##### Constructor for *Keyframe*
--- ***
--- Create a keyframe.
--- @param  time number  time
--- @param value number value
--- @return Keyframe
function Keyframe( time, value) end

--- ##### Type *Light* inherits *Behaviour*
--- ***
--- Script interface for light components.<br> Use this to control all aspects of Unity's lights. The properties are an exact match for the values shown in the Inspector.<br> Check out [Unity Light API](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/Light.html)
--- @class Light
--- @field areaSize Vector2 The size of the area light (Editor only).
--- @field bakingOutput LightBakingOutput This property describes the output of the last Global Illumination bake.
--- @field bounceIntensity number The multiplier that defines the strength of the bounce lighting.
--- @field boundingSphereOverride Vector4 Bounding sphere used to override the regular light bounding sphere during culling.
--- @field color Color The color of the light.
--- @field commandBufferCount number Number of command buffers set up on this light (Read Only).
--- @field cookie Texture The cookie texture projected by the light.
--- @field cookieSize number The size of a directional light's cookie.
--- @field cullingMask number This is used to light certain objects in the Scene selectively.
--- @field flare Flare The flare asset to use for this light.
--- @field innerSpotAngle number The angle of the light's spotlight inner cone in degrees.
--- @field intensity number The Intensity of a light is multiplied with the Light color.
--- @field layerShadowCullDistancesv number[] Per-light, per-layer shadow culling distances.
--- @field range number The range of the light.
--- @field renderingLayerMask number Determines which rendering LayerMask this Light affects.
--- @field renderMode LightRenderMode How to render the light.
--- @field shadowAngle number Controls the amount of artificial softening applied to the edges of shadows cast by directional lights.
--- @field shadowBias number Shadow mapping constant bias.
--- @field shadowCustomResolution number The custom resolution of the shadow map.
--- @field shadowMatrixOverride Matrix4x4 Projection matrix used to override the regular light matrix during shadow culling.
--- @field shadowNearPlane number Near plane value to use for shadow frustums.
--- @field shadowNormalBias number Shadow mapping normal-based bias.
--- @field shadowRadius number Controls the amount of artificial softening applied to the edges of shadows cast by the Point or Spot light.
--- @field shadowResolution LightShadowResolution The resolution of the shadow map.
--- @field shadows LightShadows How this light casts shadows
--- @field shape LightShape This property describes the shape of the spot light. Only Scriptable Render Pipelines use this property; the built-in renderer does not support it.
--- @field spotAngle number The angle of the light's spotlight cone in degrees.
--- @field type LightType The type of the light.
--- @field useBoundingSphereOverride boolean Set to true to override light bounding sphere for culling.
--- @field useColorTemperature boolean Set to true to use the color temperature.
--- @field useShadowMatrixOverride boolean Set to true to enable custom matrix for culling during shadows.
--- @field enabled boolean **Inherited**  |  Enabled Behaviours are Updated, disabled Behaviours are not.
--- @field isActiveAndEnabled boolean **Inherited**  |  Has the Behaviour had active and enabled called?
--- @field gameObject GameObject **Read-Only**  **Inherited**  |  The game object this component is attached to. A component is always attached to a game object.
--- @field tag string **Read-Only**  **Inherited**  |  The tag of this game object.
--- @field transform Transform **Read-Only**  **Inherited**  |  The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
Light = {}

--- ##### Method Inherited from *Behaviour*
--- ***
--- Calls the method named methodName on every Lua Script in this game object or any of its children.
--- @param methodName string Name of the method to call.
--- @param parameter any? **Optional**(default = nil) Optional parameter to pass to the method (can be any value).
function Light.BroadcastMessage(methodName, parameter) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function Light.CompareTag(tag) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # Array of all Lua scripts that attached to the game object.
function Light.GetAllLuaScripts() end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the component of Type type if the game object has one attached, nil if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # the component of Type type
function Light.GetComponent(type) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function Light.GetComponentInChildren(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function Light.GetComponentInParent(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function Light.GetComponents(type) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function Light.GetComponentsInChildren(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function Light.GetComponentsInParent(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Calls the method named methodName on every Lua Script in this game object. 
--- @param methodName string Name of the method to call.
--- @param value any? **Optional**(default = nil) Optional parameter for the method.
function Light.SendMessage(methodName, value) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Calls the method named methodName on every LuaScript in this game object and on every ancestor of the behaviour.
--- @param methodName string Name of method to call.
--- @param value any? **Optional**(default = nil) Optional parameter value for the method.
function Light.SendMessageUpwards(methodName, value) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of the component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or nil.
function Light.TryGetComponent(type) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function Light.GetInstanceID() end

--- ##### Type *LightBakingOutput*
--- ***
--- Struct describing the result of a Global Illumination bake for a given light. <br> The example below demonstrates how you can check the baked status of a light and change its active state.
--- @class LightBakingOutput
--- @field isBaked boolean Is the light contribution already stored in lightmaps and/or lightprobes?
--- @field lightmapBakeType LightmapBakeType This property describes what part of a light's contribution was baked.
--- @field occlusionMaskChannel number In case of a LightmapBakeType.Mixed light, contains the index of the occlusion mask channel to use if any, otherwise -1.
--- @field probeOcclusionLightIndex number In case of a LightmapBakeType.Mixed light, contains the index of the light as seen from the occlusion probes point of view if any, otherwise -1.
LightBakingOutput = {}

--- ##### Constructor for *LightBakingOutput*
--- ***
--- Create new Light Baking Output
--- @return LightBakingOutput
function LightBakingOutput() end

--- ##### Type *LineRenderer* inherits *Renderer*
--- ***
--- The line renderer is used to draw free-floating lines in 3D space.
--- @class LineRenderer
--- @field alignment LineAlignment Select whether the line will face the camera, or the orientation of the Transform Component.
--- @field endColor Color Set the color at the end of the line.
--- @field endWidth number Set the width at the end of the line.
--- @field generateLightingData boolean Configures a line to generate Normals and Tangents. With this data, Scene lighting can affect the line via Normal Maps and the Unity Standard Shader, or your own custom-built Shaders.
--- @field loop boolean Connect the start and end positions of the line together to form a continuous loop.
--- @field numCapVertices number Set this to a value greater than 0, to get rounded corners on each end of the line.
--- @field numCornerVertices number Set this to a value greater than 0, to get rounded corners between each segment of the line.
--- @field positionCount number Set/get the number of vertices.
--- @field shadowBias number Apply a shadow bias to prevent self-shadowing artifacts. The specified value is the proportion of the line width at each segment.
--- @field startColor Color Set the color at the start of the line.
--- @field startWidth number Set the width at the start of the line.
--- @field textureMode LineTextureMode Choose whether the U coordinate of the line texture is tiled or stretched.
--- @field useWorldSpace boolean If enabled, the lines are defined in world space.
--- @field widthCurve AnimationCurve Set the curve describing the width of the line at various points along its length.
--- @field allowOcclusionWhenDynamic boolean **Inherited**  |  Controls if dynamic occlusion culling should be performed for this renderer.
--- @field bounds Bounds **Inherited**  |  The bounding volume of the renderer (Read Only).
--- @field enabled boolean **Inherited**  |  Makes the rendered 3D object visible if enabled.
--- @field forceRenderingOff boolean **Inherited**  |  Allows turning off rendering for a specific component.
--- @field isPartOfStaticBatch boolean **Inherited**  |  Has this renderer been statically batched with any other renderers? (Read-Only)
--- @field isVisible boolean **Inherited**  |  Is this renderer visible in any camera? (Read Only)
--- @field lightmapIndex number **Inherited**  |  The index of the baked lightmap applied to this renderer. (Read-Only)
--- @field lightmapScaleOffset Vector4 **Inherited**  |  The UV scale & offset used for a lightmap. (Read-Only)
--- @field lightProbeProxyVolumeOverride GameObject **Inherited**  |  If set, the Renderer will use the Light Probe Proxy Volume component attached to the source GameObject.
--- @field lightProbeUsage LightProbeUsage **Inherited**  |  The light probe interpolation type.
--- @field localToWorldMatrix Matrix4x4 **Inherited**  |  Matrix that transforms a point from local space into world space (Read Only).
--- @field material Material **Inherited**  |  Returns the first instantiated Material assigned to the renderer. Modifying material will change the material for this object only.
--- @field materials Material[] **Inherited**  |  Returns all the instantiated materials of this object.
--- @field motionVectorGenerationMode MotionVectorGenerationMode **Inherited**  |  Specifies the mode for motion vector rendering.
--- @field probeAnchor Transform **Inherited**  |  If set, Renderer will use this Transform's position to find the light or reflection probe. Otherwise the center of Renderer's AABB will be used.
--- @field realtimeLightmapIndex number **Inherited**  |  The index of the realtime lightmap applied to this renderer.
--- @field realtimeLightmapScaleOffset Vector4 **Inherited**  |  The UV scale & offset used for a realtime lightmap.
--- @field receiveShadows boolean **Inherited**  |  Does this object receive shadows?
--- @field reflectionProbeUsage ReflectionProbeUsage **Inherited**  |  Should reflection probes be used for this Renderer?
--- @field rendererPriority number **Inherited**  |  This value sorts renderers by priority. Lower values are rendered first and higher values are rendered last.
--- @field renderingLayerMask number **Inherited**  |  Determines which rendering layer this renderer lives on.
--- @field shadowCastingMode shadowCastingMode **Inherited**  |  Does this object cast shadows?
--- @field sharedMaterial Material **Inherited**  |  The shared material of this object.
--- @field sharedMaterials Material[] **Inherited**  |  All the shared materials of this object.
--- @field sortingLayerID number **Inherited**  |  Unique ID of the Renderer's sorting layer.
--- @field sortingLayerName string **Inherited**  |  Name of the Renderer's sorting layer.
--- @field sortingOrder number **Inherited**  |  Renderer's order within a sorting layer.
--- @field worldToLocalMatrix Matrix4x4 **Inherited**  |  Matrix that transforms a point from world space into local space (Read Only).
--- @field gameObject GameObject **Read-Only**  **Inherited**  |  The game object this component is attached to. A component is always attached to a game object.
--- @field tag string **Read-Only**  **Inherited**  |  The tag of this game object.
--- @field transform Transform **Read-Only**  **Inherited**  |  The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
LineRenderer = {}

--- ##### Method Inherited from *Renderer*
--- ***
--- Returns all the instantiated materials of this object.
--- @return Material # all the instantiated materials of this object.
function LineRenderer.GetMaterials() end

--- ##### Method Inherited from *Renderer*
--- ***
--- Get per-Renderer or per-Material property block.
--- @param materialIndex number? **Optional**(default = -1) The index of the Material you want to get overridden parameters from. The index ranges from 0 to #Renderer.sharedMaterials-1.
--- @return MaterialPropertyBlock # per-Renderer or per-Material property block.
function LineRenderer.GetPropertyBlock(materialIndex) end

--- ##### Method Inherited from *Renderer*
--- ***
--- Returns all the shared materials of this object.
--- @return Material[] # all the shared materials of this object.
function LineRenderer.GetSharedMaterials() end

--- ##### Method Inherited from *Renderer*
--- ***
--- Returns true if the Renderer has a material property block attached via SetPropertyBlock.
--- @return boolean # true if the Renderer has a material property block attached via SetPropertyBlock.
function LineRenderer.HasPropertyBlock() end

--- ##### Method Inherited from *Renderer*
--- ***
--- Lets you set or clear per-renderer or per-material parameter overrides.
--- @param properties MaterialPropertyBlock Property block with values you want to override.
--- @param materialIndex number? **Optional**(default = -1) The index of the Material you want to override the parameters of. The index ranges from 0 to #Renderer.sharedMaterial-1.
function LineRenderer.SetPropertyBlock(properties, materialIndex) end

--- ##### Method Inherited from *Renderer*
--- ***
--- Calls the method named methodName on every Lua Script in this game object or any of its children.
--- @param methodName string Name of the method to call.
--- @param parameter any? **Optional**(default = nil) Optional parameter to pass to the method (can be any value).
function LineRenderer.BroadcastMessage(methodName, parameter) end

--- ##### Method Inherited from *Renderer*
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function LineRenderer.CompareTag(tag) end

--- ##### Method Inherited from *Renderer*
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # Array of all Lua scripts that attached to the game object.
function LineRenderer.GetAllLuaScripts() end

--- ##### Method Inherited from *Renderer*
--- ***
--- Returns the component of Type type if the game object has one attached, nil if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # the component of Type type
function LineRenderer.GetComponent(type) end

--- ##### Method Inherited from *Renderer*
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function LineRenderer.GetComponentInChildren(t) end

--- ##### Method Inherited from *Renderer*
--- ***
--- Returns the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function LineRenderer.GetComponentInParent(t) end

--- ##### Method Inherited from *Renderer*
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function LineRenderer.GetComponents(type) end

--- ##### Method Inherited from *Renderer*
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function LineRenderer.GetComponentsInChildren(t) end

--- ##### Method Inherited from *Renderer*
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function LineRenderer.GetComponentsInParent(t) end

--- ##### Method Inherited from *Renderer*
--- ***
--- Calls the method named methodName on every Lua Script in this game object. 
--- @param methodName string Name of the method to call.
--- @param value any? **Optional**(default = nil) Optional parameter for the method.
function LineRenderer.SendMessage(methodName, value) end

--- ##### Method Inherited from *Renderer*
--- ***
--- Calls the method named methodName on every LuaScript in this game object and on every ancestor of the behaviour.
--- @param methodName string Name of method to call.
--- @param value any? **Optional**(default = nil) Optional parameter value for the method.
function LineRenderer.SendMessageUpwards(methodName, value) end

--- ##### Method Inherited from *Renderer*
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of the component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or nil.
function LineRenderer.TryGetComponent(type) end

--- ##### Method Inherited from *Renderer*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function LineRenderer.GetInstanceID() end

--- ##### Type *LUA*
--- ***
--- Interface with Lua scripting in the Massive Loop.
--- @class LUA
--- @field script LuaBehaviour **Static**  **Read-Only**  |  Reference to the script object.
LUA = {}

--- ##### Static Method
--- ***
--- You can import and use any Lua script (files with .lua extension) that you place directly under the Assets folder or other subdirectories with obvious exceptions of MLSDK and GIZMOS folder.
--- @param fileName string The name of the Lua Script file without the path.
--- @return table # The library object if exists.
function LUA:Import(fileName) end

--- ##### Type *LuaBehaviour* inherits *Behaviour*
--- ***
--- LuaBehaviour is the main class every Lua component script derives. When creating a Lua script in a component, you need to get and extend the instance of this object. This object references the component in which you attach your Lua script into. 
--- ##### example
--- You can get the instance of the LuaBehaviour by calling ‘LUA.script’. 
--- ```
--- do
--- 	---@type LuaBehaviour
--- 	local script = LUA.script;
--- 
--- end
--- ```
--- @class LuaBehaviour
--- @field id string **Read-Only**  |  A Unique identifier for this Lua script. This id is same for this script for all the clients in the room.
--- @field enabled boolean **Inherited**  |  Enabled Behaviours are Updated, disabled Behaviours are not.
--- @field isActiveAndEnabled boolean **Inherited**  |  Has the Behaviour had active and enabled called?
--- @field gameObject GameObject **Read-Only**  **Inherited**  |  The game object this component is attached to. A component is always attached to a game object.
--- @field tag string **Read-Only**  **Inherited**  |  The tag of this game object.
--- @field transform Transform **Read-Only**  **Inherited**  |  The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
--- @field FixedUpdate fun() # **Message** | Frame-rate independent message for physics calculations.
--- @field LateUpdate fun() # **Message** | LateUpdate is called every frame.
--- @field OnAnimatorIK fun(layerIndex : number) # **Message** | Callback for setting up animation IK (inverse kinematics).
--- @field OnAnimatorMove fun() # **Message** | Callback for processing animation movements for modifying root motion.
--- @field OnBecameInvisible fun() # **Message** | OnBecameInvisible is called when the object is no longer visible by any camera.
--- @field OnBecameVisible fun() # **Message** | OnBecameVisible is called when the object became visible by any camera.
--- @field OnBecomeOwner fun() # **Message** | Called when the current client becomes the owner of the object.
--- @field OnCollisionEnter fun(other : Collision) # **Message** | OnCollisionEnter is called when this collider/rigidbody has begun touching another rigidbody/collider.
--- @field OnCollisionExit fun(other : Collision) # **Message** | OnCollisionExit is called when this collider/rigidbody has stopped touching another rigidbody/collider.
--- @field OnCollisionStay fun(other : Collision) # **Message** | OnCollisionStay is called once per frame for every collider/rigidbody that is touching rigidbody/collider.
--- @field OnDisable fun() # **Message** | This function is called when the behaviour becomes disabled.
--- @field OnEnable fun() # **Message** | This function is called when the object becomes enabled and active.
--- @field OnLostOwnership fun() # **Message** | Called when the current client loses the network ownership of the object.
--- @field OnOwnerChanged fun(player : MLPlayer) # **Message** | OnOwnerChanged called when the current Network owner is changed. The new owner is passed as argument. Network ownership allows a certain client to modify properties of a game object if that game object or any of its parent or grandparents are synchronized using MLSynchronizer.
--- @field OnParticleCollision fun(gameObject : GameObject) # **Message** | OnParticleCollision is called when a particle hits a Collider.
--- @field OnTriggerEnter fun(other : Collider) # **Message** | When a GameObject collides with another GameObject, Unity calls OnTriggerEnter.
--- @field OnTriggerExit fun(other : Collider) # **Message** | OnTriggerExit is called when the Collider other has stopped touching the trigger.
--- @field OnTriggerStay fun(other : Collider) # **Message** | OnTriggerStay is called almost all the frames for every Collider other that is touching the trigger. The function is on the physics timer so it won't necessarily run every frame.
--- @field Start fun() # **Message** | Start is called on the frame when a script is enabled just before any of the Update methods are called the first time.
--- @field Update fun() # **Message** | Update is called every frame, if the component is enabled.
LuaBehaviour = {}

--- ##### Method
--- ***
--- Starts the passed function as a coroutine function.
--- @param coroutineFunction function The name of the function to be started as a coroutine. Must have at least one coroutine.yield() call with in it.
--- @param _args ... Arguments to passed as parameters to the coroutine function.
--- @return Coroutine # Reference to created coroutine.
function LuaBehaviour.StartCoroutine(coroutineFunction, ...) end

--- ##### Method
--- ***
--- Stops all coroutines running on this behaviour.
function LuaBehaviour.StopAllCoroutines() end

--- ##### Method
--- ***
--- Stops the coroutine reference by the Coroutine Object. 
--- @param routine Coroutine Reference to the coroutine reference, returned by StartCoroutine()
function LuaBehaviour.StopCoroutine(routine) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Calls the method named methodName on every Lua Script in this game object or any of its children.
--- @param methodName string Name of the method to call.
--- @param parameter any? **Optional**(default = nil) Optional parameter to pass to the method (can be any value).
function LuaBehaviour.BroadcastMessage(methodName, parameter) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function LuaBehaviour.CompareTag(tag) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # Array of all Lua scripts that attached to the game object.
function LuaBehaviour.GetAllLuaScripts() end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the component of Type type if the game object has one attached, nil if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # the component of Type type
function LuaBehaviour.GetComponent(type) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function LuaBehaviour.GetComponentInChildren(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function LuaBehaviour.GetComponentInParent(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function LuaBehaviour.GetComponents(type) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function LuaBehaviour.GetComponentsInChildren(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function LuaBehaviour.GetComponentsInParent(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Calls the method named methodName on every Lua Script in this game object. 
--- @param methodName string Name of the method to call.
--- @param value any? **Optional**(default = nil) Optional parameter for the method.
function LuaBehaviour.SendMessage(methodName, value) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Calls the method named methodName on every LuaScript in this game object and on every ancestor of the behaviour.
--- @param methodName string Name of method to call.
--- @param value any? **Optional**(default = nil) Optional parameter value for the method.
function LuaBehaviour.SendMessageUpwards(methodName, value) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of the component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or nil.
function LuaBehaviour.TryGetComponent(type) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function LuaBehaviour.GetInstanceID() end

--- ##### Type *LuaEventId*
--- ***
--- An identifying object for a Lua Event handler. Used for removing the handlers from Lua Event System  LuaEventId is unique for the function and the event, therefore adding the same function under two different event names will result in two different LuaEventId.
--- @class LuaEventId
LuaEventId = {}

--- ##### Type *LuaEvents*
--- ***
--- In game event system handler. Check out [tutorial on event handlers](https://sdk.massiveloop.com/getting_started/scripting/eventSystem.html). 
--- ##### example
--- let's imagine we have two scripts. In one of them, we attach a function as a handler for an event and Invoke it in another script
--- In script A, we create a function `myEventHandler` and attach it to the event `OnMyEvent`.
--- script A:
--- ```
--- do
---    local scriptA = LUA.Script;
--- 
---    -- define that handler function 
---    function myEventHandler(message)
---         Debug.Log("The Evnet handled "..message);  
---    end
--- 
--- 
---    function scriptA.start()
---         -- attach the handler to the event. 
---         eventId = LuaEvents.Add("OnMyEvent", myEventHandler);  
---    end
--- 
--- end
--- ```
--- In script B, we can invoke the event.
--- 
--- Script B:
--- ``` lua
--- do
---     local scriptB = LUA.Script;
--- 
---     function scriptB.start()
---         -- invoke the event when appropiate 
---         LuaEvents.Invoke("OnMyEvent", "Hello");
---     end
--- 
--- end
--- ```
--- You can remove the handler as well.
--- 
--- Script A:
--- ``` lua
--- do
---    local scriptA = LUA.Script;
--- 
---    -- define that handler function 
---    function myEventHandler(message)
---         Debug.log("The Evnet handled "..message);  
---    end
--- 
--- 
---    function scriptA.start()
---         -- attach the handler to the event. 
---         eventId = LuaEvents.Add("OnMyEvent", myEventHandler); 
--- 
---         -- remove the handler 
---         LuaEvents.Remove(eventId);
---    end
--- 
--- end
--- ```
--- @class LuaEvents
LuaEvents = {}

--- ##### Static Method
--- ***
--- Adds the handler function to the event with name provided on eventName. The eventName doesn't need to be unique, or defined before. Throws error if handler is not a callable type. Each handler will receive a unique key (LuaEventId) which can used to remove the handler.
--- @param eventName string The name of the event this handler get's attached to.
--- @param handler function The handler function.
--- @return LuaEventId #  A unique key identifying the handler.
function LuaEvents:Add(eventName, handler) end

--- ##### Static Method
--- ***
--- Like `Add()`, however this method adds the handler to the Local Event. Local event is an event only defined for individual Game Object and Script combination.
--- @param script LuaBehaviour The current running script object from `LUA.script`.
--- @param eventName string The name of the local event. This will only defined with in GameObject + LuaScript combination. It will not cause collision with global events. 
--- @param handler function The handler function. 
--- @return LuaEventId # Id unique to event name and attached handler
function LuaEvents:AddLocal(script, eventName, handler) end

--- ##### Static Method
--- ***
--- Returns the total number of events registered. Can be used by simplified operator: `#LuaEvents;`
--- @return number # total number of events.
function LuaEvents:GetNumberOfEvents() end

--- ##### Static Method
--- ***
--- Invokes the event which is specified in eventName. You can pass any amount of arguments.
--- @param evnetName string The name of the event to invoke.
--- @param _optional_arguments ... You can pass any amount, type of arguments.
function LuaEvents:Invoke(evnetName, ...) end

--- ##### Static Method
--- ***
--- Invokes the event which is specified in eventName for **all players** in the session joined to the world **including the sender**. 
--- @param evnetName string  The name of the event to invoke.
--- @param _optional_arguments ... You can pass any amount, type of arguments.
function LuaEvents:InvokeForAll(evnetName, ...) end

--- ##### Static Method
--- ***
--- Invokes the event which is specified in eventName for **master client** and the **sender**.
--- @param eventName string The name of the event to invoke.
--- @param _optional_arguments ... You can pass any amount, type of arguments.
function LuaEvents:InvokeForMaster(eventName, ...) end

--- ##### Static Method
--- ***
--- Invokes the event which is specified in `eventName` for **master client** , **excluding the sender**.
--- @param eventName string The name of the event to invoke.
--- @param _optional_arguments ... You can pass any amount, type of arguments.
function LuaEvents:InvokeForMasterOnly(eventName, ...) end

--- ##### Static Method
--- ***
--- Invokes the event which is specified in eventName for **all players** in the session joined to the world **excluding the sender**.
--- @param evnetName string The name of the event to invoke.
--- @param _optional_arguments ... You can pass any amount, type of arguments.
function LuaEvents:InvokeForOthers(evnetName, ...) end

--- ##### Static Method
--- ***
--- Like the `Invoke()` but invokes a local event.
--- @param script LuaBehaviour The current running script object from `LUA.script`.
--- @param eventName string The name of the local event.
--- @param optional_arguments ... Optional parameters to pass. 
function LuaEvents:InvokeLocal(script, eventName, ...) end

--- ##### Static Method
--- ***
--- Like `InvokeForAll()` but invokes the local event that defined in the exact similar game object and Lua Script in all the clients. This requires for that game object to be existed during the build or instantiated using network methods. 
--- @param script LuaBehaviour The current running script object from `LUA.script`.
--- @param eventName string The name of the local event.
--- @param optional_arguments ... 
function LuaEvents:InvokeLocalForAll(script, eventName, ...) end

--- ##### Static Method
--- ***
--- Like `InvokeForMaster()` but invokes the local event that defined in the exact similar game object and Lua Script in all the master client. This requires for that game object to be existed during the build or instantiated using network methods. 
--- @param script LuaBehaviour The current running script object from `LUA.script`.
--- @param eventName string The name of the local event.
--- @param optional_arguments ... Optional parameters to pass.
function LuaEvents:InvokeLocalForMaster(script, eventName, ...) end

--- ##### Static Method
--- ***
--- Invoke a local (script+gameObject specific) event over the network. 
--- @param script LuaBehaviour The local script object.
--- @param key string The name of the event.
--- @param target EventTarget The event invocation target.
--- @param players MLPlayer[] Set of players. Can be nil
--- @param _args ... Optional arguments to be passed to the invocation function. All must be able to serialized.
function LuaEvents:InvokeLocalNetwork(script, key, target, players, ...) end

--- ##### Static Method
--- ***
--- Invoke an event over the network.
--- @param key string The name of the event.
--- @param target EventTarget The event invocation target.
--- @param players MLPlayer[] Set of players. Can be nil
--- @param _args ... Optional arguments to be passed to the invocation function. All must be able to serialized.
function LuaEvents:InvokeNetwork(key, target, players, ...) end

--- ##### Static Method
--- ***
--- Removes a handler.
--- @param eventId LuaEventId  The unique key of the handler.
function LuaEvents:Remove(eventId) end

--- **Deprecated!**()
--- ***
--- ##### Type *LuaFileComponent* inherits *Component*
--- ***
--- Encapsulates the Lua Scripts when retrieved as a component. 
--- @deprecated deprecated type
--- @class LuaFileComponent
--- @field script Script The script object references the Lua script that is attached to the game object. From the script, you access the underlying game object and the callback functions.
--- @field scriptName string The name of the Lua Script File (extension omitted)
--- @field gameObject GameObject **Read-Only**  **Inherited**  |  The game object this component is attached to. A component is always attached to a game object.
--- @field tag string **Read-Only**  **Inherited**  |  The tag of this game object.
--- @field transform Transform **Read-Only**  **Inherited**  |  The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
LuaFileComponent = {}

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object or any of its children.
--- @param methodName string Name of the method to call.
--- @param parameter any? **Optional**(default = nil) Optional parameter to pass to the method (can be any value).
function LuaFileComponent.BroadcastMessage(methodName, parameter) end

--- ##### Method Inherited from *Component*
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function LuaFileComponent.CompareTag(tag) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # Array of all Lua scripts that attached to the game object.
function LuaFileComponent.GetAllLuaScripts() end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type if the game object has one attached, nil if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # the component of Type type
function LuaFileComponent.GetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function LuaFileComponent.GetComponentInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function LuaFileComponent.GetComponentInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function LuaFileComponent.GetComponents(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function LuaFileComponent.GetComponentsInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function LuaFileComponent.GetComponentsInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object. 
--- @param methodName string Name of the method to call.
--- @param value any? **Optional**(default = nil) Optional parameter for the method.
function LuaFileComponent.SendMessage(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every LuaScript in this game object and on every ancestor of the behaviour.
--- @param methodName string Name of method to call.
--- @param value any? **Optional**(default = nil) Optional parameter value for the method.
function LuaFileComponent.SendMessageUpwards(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of the component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or nil.
function LuaFileComponent.TryGetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function LuaFileComponent.GetInstanceID() end

--- ##### Type *MassiveLoop*
--- ***
--- Provides access to the Massive Loop specific APIs, Players, and other related functionalities.  
--- @class MassiveLoop
--- @field IsInDesktopMode boolean **Static**  **Read-Only**  |  Is the client running in desktop mode? 
--- @field IsLocalMode boolean **Static**  **Read-Only**  |  True if the massive loop browser is in local mode. The local mode is when the browser is launched by the SDK editor tool to test the world locally without uploading it. This parameter can used to perform specific actions in local mode such as Debug.Log calls or other automated tests.  Local mode is never true during the normal operation. 
MassiveLoop = {}

--- ##### Static Method
--- ***
--- Accesses the local player.
--- @return MLPlayer # The Local Player
function MassiveLoop:GetLocalPlayer() end

--- ##### Static Method
--- ***
--- Opens the provided URL in the Massive Loop internal browser.
--- @param url string The URL for browser to load.
function MassiveLoop:OpenURL(url) end

--- ##### Static Method
--- ***
--- Opens the provided URL in the system default (external) browser.  
--- @param url string The URL for browser to load. 
function MassiveLoop:OpenURLExternal(url) end

--- ##### Type *Material* inherits *Object*
--- ***
--- The material class.  This class exposes all properties from a material, allowing you to animate them. You can also use it to set custom shader properties that can't be accessed through the inspector (e.g. matrices). [Unity Material](https://docs.unity3d.com/2019.4/Documentation/ScriptReference/Material.html)
--- @class Material
--- @field color Color The main color of the Material.
--- @field doubleSidedGI boolean Gets and sets whether the Double Sided Global Illumination setting is enabled for this material.
--- @field enableInstancing boolean Gets and sets whether GPU instancing is enabled for this material. 
--- @field globalIlluminationFlags MaterialGlobalIlluminationFlags Defines how the material should interact with lightmaps and lightprobes.
--- @field mainTexture Texture The main texture.
--- @field mainTextureOffset Vector2 The offset of the main texture.
--- @field mainTextureScale Vector2 The scale of the main texture.
--- @field passCount number How many passes are in this material (Read Only).
--- @field renderQueue number Render queue of this material.
--- @field shaderKeywords string[] An array containing the names of the local shader keywords that are currently enabled for this material.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
Material = {}

--- ##### Method
--- ***
--- Computes a CRC hash value from the content of the material.
--- @return number # CRC hash value from the content of the material.
function Material.ComputeCRC() end

--- ##### Method
--- ***
--- Copy properties from other material into this material.
--- @param mat Material Other material
function Material.CopyPropertiesFromMaterial(mat) end

--- ##### Method
--- ***
--- Disables a local shader keyword for this material.
--- @param keyword string The name of the local shader keyword to disable.
function Material.DisableKeyword(keyword) end

--- ##### Method
--- ***
--- Enables a local shader keyword for this material.
--- @param keyword string The name of the local shader keyword to enable.
function Material.EnableKeyword(keyword) end

--- ##### Method
--- ***
--- Returns the index of the pass passName.
--- @param passName string Name of the Pass.
--- @return number # the index of the pass passName. -1 if it does not exist.
function Material.FindPass(passName) end

--- ##### Method
--- ***
--- Get a named color value.
--- @param name string The name of the property.
--- @return Color # the named color value.
function Material.GetColor(name) end

--- ##### Method
--- ***
--- Get a named color value.
--- @param nameID number The name ID of the property
--- @return Color # the named color value.
function Material.GetColor(nameID) end

--- ##### Method
--- ***
--- Get a named color array.
--- @param name string The name of the property.
--- @return Color[] # the named color array.
function Material.GetColorArray(name) end

--- ##### Method
--- ***
--- Get a named float value.
--- @param name string The name of the property.
--- @return number # The named float value.
function Material.GetFloat(name) end

--- ##### Method
--- ***
--- Get a named float array.
--- @param name string The name of the property.
--- @return number[] # The named float array.
function Material.GetFloatArray(name) end

--- ##### Method
--- ***
--- Get a named integer value.
--- @param name string The name of the property.
--- @return number # The named integer value.
function Material.GetInt(name) end

--- ##### Method
--- ***
--- Get a named matrix value from the shader.
--- @param name string The name of the property.
--- @return Matrix4x4 # the named matrix value from the shader.
function Material.GetMatrix(name) end

--- ##### Method
--- ***
--- Get a named matrix array.
--- @param name string The name of the property.
--- @return Matrix4x4[] # The named matrix array.
function Material.GetMatrixArray(name) end

--- ##### Method
--- ***
--- Returns the name of the shader pass at index pass.
--- @param pass number pass index
--- @return string # the name of the shader pass at index pass. It will return an empty string if the pass does not exist.
function Material.GetPassName(pass) end

--- ##### Method
--- ***
--- Checks whether a given Shader pass is enabled on this Material.
--- @param passName string Shader pass name (case insensitive).
--- @return boolean # True if the Shader pass is enabled.
function Material.GetShaderPassEnabled(passName) end

--- ##### Method
--- ***
--- Get the value of material's shader tag.
--- @param tag string tag
--- @param searchFallbacks boolean if true will look for tag in all subshaders and all fallbacks
--- @return string # the value of material's shader tag.
function Material.GetTag(tag, searchFallbacks) end

--- ##### Method
--- ***
--- Get the value of material's shader tag.
--- @param tag string tag
--- @param searchFallbacks boolean If true will look for tag in all subshaders and all fallbacks.
--- @param defaultValue string If the material's shader does not define the tag, defaultValue is returned.
--- @return string # the value of material's shader tag.
function Material.GetTag(tag, searchFallbacks, defaultValue) end

--- ##### Method
--- ***
--- Get a named texture.
--- @param name string The name of the property.
--- @return Texture # The named texture.
function Material.GetTexture(name) end

--- ##### Method
--- ***
--- Gets the placement offset of texture propertyName.
--- @param name string The name of the property.
--- @return Vector2 # the placement offset of texture propertyName.
function Material.GetTextureOffset(name) end

--- ##### Method
--- ***
--- Return the name IDs of all texture properties exposed on this material.
--- @return number[] # IDs of all texture properties exposed on this material.
function Material.GetTexturePropertyNameIDs() end

--- ##### Method
--- ***
--- Returns the names of all texture properties exposed on this material.
--- @return string[] # Names of all texture properties exposed on this material.
function Material.GetTexturePropertyNames() end

--- ##### Method
--- ***
--- Gets the placement scale of texture propertyName.
--- @param name string The name of the property.
--- @return Vector2 # the placement scale of texture
function Material.GetTextureScale(name) end

--- ##### Method
--- ***
--- Get a named vector value.
--- @param name string The name of the property.
--- @return Vector4 # named vector value.
function Material.GetVector(name) end

--- ##### Method
--- ***
--- Get a named vector array.
--- @param name string The name of the property.
--- @return Vector4[] # named vector array.
function Material.GetVectorArray(name) end

--- ##### Method
--- ***
--- Checks if material's shader has a property of a given name.
--- @param name number The name of the property.
--- @return boolean # True if material's shader has a property of a given name.
function Material.HasProperty(name) end

--- ##### Method
--- ***
--- Checks whether a local shader keyword is enabled for this material.
--- @param keyword string The name of the local shader keyword to check.
--- @return boolean # true if the given local shader keyword is enabled for this material. Otherwise, returns false.
function Material.IsKeywordEnabled(keyword) end

--- ##### Method
--- ***
--- Interpolate properties between two materials.
--- @param start Material start material
--- @param _end Material end material
--- @param t  number interpolation variable [0-1]
function Material.Lerp(start, _end, t ) end

--- ##### Method
--- ***
--- Sets a named color value.
--- @param name string Property name, e.g. "_Color".
--- @param value Color Color value to set.
function Material.SetColor(name, value) end

--- ##### Method
--- ***
--- Sets a color array property.
--- @param name string Property name.
--- @param values Color[] Array of values to set.
function Material.SetColorArray(name, values) end

--- ##### Method
--- ***
--- Sets a named float value.
--- @param name string Property name, e.g. "_Glossiness".
--- @param value number Float value to set.
function Material.SetFloat(name, value) end

--- ##### Method
--- ***
--- Sets a float array property.
--- @param name string Property name.
--- @param values number[] Array of values to set.
function Material.SetFloatArray(name, values) end

--- ##### Method
--- ***
--- Sets a named integer value.
--- @param name string Property name, e.g. "_SrcBlend".
--- @param value number Integer value to set.
function Material.SetInt(name, value) end

--- ##### Method
--- ***
--- Sets a named matrix for the shader.
--- @param name string Property name, e.g. "_CubemapRotation".
--- @param value Matrix4x4 Matrix value to set.
function Material.SetMatrix(name, value) end

--- ##### Method
--- ***
--- Sets a matrix array property.
--- @param name string Property name.
--- @param values Matrix4x4[] Array of values to set.
function Material.SetMatrixArray(name, values) end

--- ##### Method
--- ***
--- Sets an override tag/value on the material.
--- @param tag string Name of the tag to set.
--- @param val string Name of the value to set. Empty string to clear the override flag.
function Material.SetOverrideTag(tag, val) end

--- ##### Method
--- ***
--- Activate the given pass for rendering.
--- @param pass number Shader pass number to setup.
--- @return boolean # If false is returned, no rendering should be done.
function Material.SetPass(pass) end

--- ##### Method
--- ***
--- Enables or disables a Shader pass on a per-Material level.
--- @param passName string Shader pass name (case insensitive).
--- @param enabled boolean Flag indicating whether this Shader pass should be enabled.
function Material.SetShaderPassEnabled(passName, enabled) end

--- ##### Method
--- ***
--- Sets a named texture.
--- @param name string Property name, e.g. "_MainTex".
--- @param value Texture Texture to set.
function Material.SetTexture(name, value) end

--- ##### Method
--- ***
--- Sets the placement offset of texture propertyName.
--- @param name string Property name, for example: "_MainTex".
--- @param value Vector2 Texture placement offset.
function Material.SetTextureOffset(name, value) end

--- ##### Method
--- ***
--- Sets the placement scale of texture propertyName.
--- @param name string Property name, e.g. "_MainTex".
--- @param value Vector2 Texture placement scale.
function Material.SetTextureScale(name, value) end

--- ##### Method
--- ***
--- Sets a named vector value.
--- @param name string Property name, e.g. "_WaveAndDistance".
--- @param value Vector4 Vector value to set.
function Material.SetVector(name, value) end

--- ##### Method
--- ***
--- Sets a vector array property.
--- @param name string Property name.
--- @param values Vector4[] Array of values to set.
function Material.SetVectorArray(name, values) end

--- ##### Method Inherited from *Object*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function Material.GetInstanceID() end

--- ##### Type *MaterialPropertyBlock*
--- ***
--- A block of material values to apply. [Unity MaterialPropertyBlock](https://docs.unity3d.com/2019.4/Documentation/ScriptReference/MaterialPropertyBlock.html)
--- @class MaterialPropertyBlock
--- @field isEmpty boolean Is the material property block empty? (Read Only)
MaterialPropertyBlock = {}

--- ##### Constructor for *MaterialPropertyBlock*
--- ***
--- Create an empty MaterialPropertyBlock.
--- @return MaterialPropertyBlock
function MaterialPropertyBlock() end

--- ##### Method
--- ***
--- Clear material property values.
function MaterialPropertyBlock.Clear() end

--- ##### Method
--- ***
--- This function copies the entire source array into a Vector4 property array named unity_ProbesOcclusion for use with instanced Shadowmask rendering.
--- @param cclusionProbes Vector4[] The array of probe occlusion values to copy from.
function MaterialPropertyBlock.CopyProbeOcclusionArrayFrom(cclusionProbes) end

--- ##### Method
--- ***
--- This function converts and copies the entire source array into 7 Vector4 property arrays named `unity_SHAr`, `unity_SHAg`, `unity_SHAb`, `unity_SHBr`, `unity_SHBg`, `unity_SHBb` and `unity_SHC` for use with instanced light probe rendering.
--- @param lightProbes SphericalHarmonicsL2[] The array of SH values to copy from.
function MaterialPropertyBlock.CopySHCoefficientArraysFrom(lightProbes) end

--- ##### Method
--- ***
--- Get a color from the property block.
--- @param name string The name of the property.
--- @return Color # color from the property block.
function MaterialPropertyBlock.GetColor(name) end

--- ##### Method
--- ***
--- Get a float from the property block.
--- @param name string The name of the property.
--- @return number # float from the property block.
function MaterialPropertyBlock.GetFloat(name) end

--- ##### Method
--- ***
--- Get a float array from the property block.
--- @param name string The name of the property.
--- @return number[] # float array from the property block.
function MaterialPropertyBlock.GetFloatArray(name) end

--- ##### Method
--- ***
--- Get an int from the property block.
--- @param name string The name of the property.
--- @return number # int from the property block.
function MaterialPropertyBlock.GetInt(name) end

--- ##### Method
--- ***
--- Get a matrix from the property block.
--- @param name string The name of the property.
--- @return Matrix4x4 # matrix from the property block.
function MaterialPropertyBlock.GetMatrix(name) end

--- ##### Method
--- ***
--- Get a matrix array from the property block.
--- @param name string The name of the property.
--- @return Matrix4x4[] #  matrix array from the property block.
function MaterialPropertyBlock.GetMatrixArray(name) end

--- ##### Method
--- ***
--- Get a texture from the property block.
--- @param name string The name of the property.
--- @return Texture # texture from the property block.
function MaterialPropertyBlock.GetTexture(name) end

--- ##### Method
--- ***
--- Get a vector from the property block.
--- @param name string The name of the property.
--- @return Vector4 # vector from the property block.
function MaterialPropertyBlock.GetVector(name) end

--- ##### Method
--- ***
--- Get a vector array from the property block.
--- @param name string The name of the property.
--- @return Vector4[] # vector array from the property block.
function MaterialPropertyBlock.GetVectorArray(name) end

--- ##### Method
--- ***
--- Set a color property.
--- @param name string The name of the property.
--- @param value Color The Color value to set.
function MaterialPropertyBlock.SetColor(name, value) end

--- ##### Method
--- ***
--- Set a float property.
--- @param name string The name of the property.
--- @param value number The float value to set.
function MaterialPropertyBlock.SetFloat(name, value) end

--- ##### Method
--- ***
--- Set a float array property.
--- @param name string The name of the property.
--- @param values number[] The array to set.
function MaterialPropertyBlock.SetFloatArray(name, values) end

--- ##### Method
--- ***
--- Adds a property to the block. If an int property with the given name already exists, the old value is replaced.
--- @param name string The name of the property.
--- @param value number The int value to set.
function MaterialPropertyBlock.SetInt(name, value) end

--- ##### Method
--- ***
--- Set a matrix property.
--- @param name string The name of the property.
--- @param value Matrix4x4 The matrix value to set.
function MaterialPropertyBlock.SetMatrix(name, value) end

--- ##### Method
--- ***
--- Set a matrix array property.
--- @param name string The name of the property.
--- @param values Matrix4x4[] The array to set.
function MaterialPropertyBlock.SetMatrixArray(name, values) end

--- ##### Method
--- ***
--- Set a texture property.
--- @param name string The name of the property.
--- @param value Texture The Texture to set.
function MaterialPropertyBlock.SetTexture(name, value) end

--- ##### Method
--- ***
--- Set a vector property.
--- @param name string The name of the property.
--- @param value Vector4 The Vector4 value to set.
function MaterialPropertyBlock.SetVector(name, value) end

--- ##### Method
--- ***
--- Set a vector array property.
--- @param name string The name of the property.
--- @param values Vector4[] The array to set.
function MaterialPropertyBlock.SetVectorArray(name, values) end

--- ##### Type *Mathf*
--- ***
--- A collection of common math functions.<br> [Unity Mathf](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/Mathf.html)
--- @class Mathf
--- @field Deg2Rad number **Static**  **Read-Only**  |  Degrees-to-radians conversion constant (Read Only).
--- @field Epsilon number **Static**  **Read-Only**  |  A tiny numerical value (Read Only). The smallest value that a number (i.e. double) can have different from zero.
--- @field Infinity number **Static**  **Read-Only**  |  A representation of positive infinity (Read Only).
--- @field NegativeInfinity number **Static**  **Read-Only**  |  A representation of negative infinity (Read Only).
--- @field PI number **Static**  **Read-Only**  |  The well-known 3.14159265358979... value (Read Only).
--- @field Rad2Deg number **Static**  **Read-Only**  |  Radians-to-degrees conversion constant (Read Only).
Mathf = {}

--- ##### Static Method
--- ***
--- Returns the absolute value of f.
--- @param value number value
--- @return number # the absolute value of value.
function Mathf:Abs(value) end

--- ##### Static Method
--- ***
--- Returns the arc-cosine of f - the angle in radians whose cosine is f.
--- @param f number value
--- @return number # the arc-cosine of f
function Mathf:Acos(f) end

--- ##### Static Method
--- ***
--- Compares two floating point values and returns true if they are similar.
--- @param a number first value
--- @param b number Second value
--- @return boolean # returns true if they are similar.
function Mathf:Approximately(a, b) end

--- ##### Static Method
--- ***
--- Returns the arc-sine of f - the angle in radians whose sine is f.
--- @param f number value
--- @return number #  the arc-sine of f
function Mathf:Asin(f) end

--- ##### Static Method
--- ***
--- Returns the arc-tangent of f - the angle in radians whose tangent is f.
--- @param f number Value
--- @return number # the arc-tangent of f
function Mathf:Atan(f) end

--- ##### Static Method
--- ***
--- Returns the angle in radians whose Tan is y/x.
--- @param y number y
--- @param x number x
--- @return number # The angle between the x-axis and a 2D vector starting at zero and terminating at (x,y).
function Mathf:Atan2(y, x) end

--- ##### Static Method
--- ***
--- Returns the smallest integer greater to or equal to f.
--- @param f number Value
--- @return number # the smallest integer greater to or equal to f.
function Mathf:Ceil(f) end

--- ##### Static Method
--- ***
--- Clamps the given value between the given minimum float and maximum float values. Returns the given value if it is within the min and max range.
--- @param value number The floating point value to restrict inside the range defined by the min and max values.
--- @param min number The minimum floating point value to compare against.
--- @param max number The maximum floating point value to compare against.
--- @return number # The result between the min and max values.
function Mathf:Clamp(value, min, max) end

--- ##### Static Method
--- ***
--- Clamps value between 0 and 1 and returns value.
--- @param value number value
--- @return number # Clamped value between 0 and 1
function Mathf:Clamp01(value) end

--- ##### Static Method
--- ***
--- Returns the closest power of two value.
--- @param value number value
--- @return number # 
function Mathf:ClosestPowerOfTwo(value) end

--- ##### Static Method
--- ***
--- Convert a color temperature in Kelvin to RGB color.
--- @param Kelvin number Temperature in Kelvin. Range 1000 to 40000 Kelvin.
--- @return Color # Correlated Color Temperature as floating point RGB color.
function Mathf:CorrelatedColorTemperatureToRGB(Kelvin) end

--- ##### Static Method
--- ***
--- Returns the cosine of angle f.
--- @param f number The input angle, in radians.
--- @return number # The return value between -1 and 1.
function Mathf:Cos(f) end

--- ##### Static Method
--- ***
--- Calculates the shortest difference between two given angles given in degrees.
--- @param current number current
--- @param target number target
--- @return number # shortest difference between two given angles given in degrees.
function Mathf:DeltaAngle(current, target) end

--- ##### Static Method
--- ***
--- Returns e raised to the specified power.
--- @param power number power
--- @return number # e raised to the specified power.
function Mathf:Exp(power) end

--- ##### Static Method
--- ***
--- Returns the largest integer smaller than or equal to f.
--- @param f number Value
--- @return number # largest integer smaller than or equal to f.
function Mathf:Floor(f) end

--- ##### Static Method
--- ***
--- Converts the given value from gamma (sRGB) to linear color space.
--- @param value number value
--- @return number # Given value in Linear Space
function Mathf:GammaToLinearSpace(value) end

--- ##### Static Method
--- ***
--- Calculates the linear parameter t that produces the interpolant value within the range [a, b].
--- @param a number Start value.
--- @param b number End value.
--- @param value number Value between start and end.
--- @return number # Percentage of value between start and end.
function Mathf:InverseLerp(a, b, value) end

--- ##### Static Method
--- ***
--- Returns true if the value is power of two.
--- @param value number value
--- @return boolean # true if the value is power of two.
function Mathf:IsPowerOfTwo(value) end

--- ##### Static Method
--- ***
--- Linearly interpolates between a and b by t.
--- @param a number The start value.
--- @param b number The end value.
--- @param t number The interpolation value between the two floats.
--- @return number # The interpolated float result between the two float values.
function Mathf:Lerp(a, b, t) end

--- ##### Static Method
--- ***
--- Same as Lerp but makes sure the values interpolate correctly when they wrap around 360 degrees.
--- @param a number The start angle in degrees.
--- @param b number The end angle in degrees.
--- @param t number The interpolation value between the two floats. Clamped to the range [0, 1]
--- @return number # The interpolated float result between the two float values.
function Mathf:LerpAngle(a, b, t) end

--- ##### Static Method
--- ***
--- Linearly interpolates between a and b by t with no limit to t.
--- @param a number The start value.
--- @param b number The end value.
--- @param t number The interpolation between the two floats.
--- @return number # The float value as a result from the linear interpolation.
function Mathf:LerpUnclamped(a, b, t) end

--- ##### Static Method
--- ***
--- Returns the logarithm of a specified number in a specified base.
--- @param f number value
--- @param p number base
--- @return number # logarithm of a specified number in a specified base.
function Mathf:Log(f, p) end

--- ##### Static Method
--- ***
--- Returns the natural (base e) logarithm of a specified number.
--- @param f number Value
--- @return number # the natural (base e) logarithm of a specified number.
function Mathf:Log(f) end

--- ##### Static Method
--- ***
--- Returns the base 10 logarithm of a specified number.
--- @param f number Value
--- @return number # the base 10 logarithm of a specified number.
function Mathf:Log10(f) end

--- ##### Static Method
--- ***
--- Returns largest of two or more values.
--- @param a number a
--- @param b number b
--- @return number # largest of a or b.
function Mathf:Max(a, b) end

--- ##### Static Method
--- ***
--- Returns largest of two or more values.
--- @param  values number[]  values
--- @return number # Returns the largest of the values.
function Mathf:Max( values) end

--- ##### Static Method
--- ***
--- Returns the smallest of two values.
--- @param a number a
--- @param b number b
--- @return number # smallest of two values.
function Mathf:Min(a, b) end

--- ##### Static Method
--- ***
--- Returns the smallest of the values.
--- @param  values number[]  values
--- @return number # smallest of the values.
function Mathf:Min( values) end

--- ##### Static Method
--- ***
--- Moves a value current towards target.
--- @param current number The current value.
--- @param target number The value to move towards.
--- @param maxDelta number The maximum change that should be applied to the value.
--- @return number #  Moved value current towards target.
function Mathf:MoveTowards(current, target, maxDelta) end

--- ##### Static Method
--- ***
--- Same as MoveTowards but makes sure the values interpolate correctly when they wrap around 360 degrees.
--- @param current number current
--- @param target number target
--- @param maxDelta number maxDelta
--- @return number # Moves value of current towards target.
function Mathf:MoveTowardsAngle(current, target, maxDelta) end

--- ##### Static Method
--- ***
--- Returns the next power of two that is equal to, or greater than, the argument.
--- @param value number value
--- @return number # the next power of two that is equal to, or greater than, the argument.
function Mathf:NextPowerOfTwo(value) end

--- ##### Static Method
--- ***
--- Generate 2D Perlin noise.
--- @param x number X-coordinate of sample point.
--- @param y number Y-coordinate of sample point.
--- @return number # Value between 0.0 and 1.0. (Return value might be slightly below 0.0 or beyond 1.0.)
function Mathf:PerlinNoise(x, y) end

--- ##### Static Method
--- ***
--- PingPong returns a value that will increment and decrement between the value 0 and length.
--- @param t number a self-incrementing value
--- @param length number length
--- @return number # a value that will increment and decrement between the value 0 and length.
function Mathf:PingPong(t, length) end

--- ##### Static Method
--- ***
--- Returns f raised to power p.
--- @param f number value
--- @param p number Power
--- @return number #  f raised to power p.
function Mathf:Pow(f, p) end

--- ##### Static Method
--- ***
--- Loops the value t, so that it is never larger than length and never smaller than 0.
--- @param t number t
--- @param length number length
--- @return number # Looped value
function Mathf:Repeat(t, length) end

--- ##### Static Method
--- ***
--- Returns f rounded to the nearest integer.
--- @param f number Value
--- @return number # f rounded to the nearest integer.
function Mathf:Round(f) end

--- ##### Static Method
--- ***
--- Returns the sign of f.
--- @param f number Value
--- @return number # value is 1 when f is positive or zero, -1 when f is negative.
function Mathf:Sign(f) end

--- ##### Static Method
--- ***
--- Returns the sine of angle f.
--- @param f number The input angle, in radians.
--- @return number # The return value between -1 and +1.
function Mathf:Sin(f) end

--- ##### Static Method
--- ***
--- Interpolates between min and max with smoothing at the limits.
--- @param from number from
--- @param to number to
--- @param t number t
--- @return number # Interpolated value between min and max with smoothing at the limits.
function Mathf:SmoothStep(from, to, t) end

--- ##### Static Method
--- ***
--- Returns square root of f.
--- @param f number value
--- @return number # square root of f.
function Mathf:Sqrt(f) end

--- ##### Static Method
--- ***
--- Returns the tangent of angle f in radians.
--- @param f number Value
--- @return number # the tangent of angle f in radians.
function Mathf:Tan(f) end

--- ##### Type *Matrix4x4*
--- ***
---  standard 4x4 transformation matrix.
--- @class Matrix4x4
--- @field [index] number Access element at sequential index (1..16 inclusive).
--- @field [row, column] number Access element at [row, column].
--- @field decomposeProjection FrustumPlanes This property takes a projection matrix and returns the six plane coordinates that define a projection frustum.
--- @field determinant number **Read-Only**  |  The determinant of the matrix. (Read Only)
--- @field identity Matrix4x4 **Static**  **Read-Only**  |  Returns the identity matrix (Read Only).
--- @field inverse Matrix4x4 **Read-Only**  |  The inverse of this matrix. (Read Only)
--- @field isIdentity boolean **Read-Only**  |  Checks whether this is an identity matrix. (Read Only)
--- @field lossyScale Vector3 **Read-Only**  |  Attempts to get a scale value from the matrix. (Read Only)
--- @field rotation Quaternion Attempts to get a rotation quaternion from this matrix. 
--- @field transpose Matrix4x4 **Read-Only**  |  Returns the transpose of this matrix (Read Only).
--- @field zero Matrix4x4 **Static**  **Read-Only**  |  Returns a matrix with all elements set to zero (Read Only).
--- @operator mul(Matrix4x4) : Matrix4x4 # Multiplies two matrices.
--- @operator mul(Vector4) : Vector4 # Transforms a Vector4 by a matrix.
Matrix4x4 = {}

--- ##### Method
--- ***
--- Get a column of the matrix.<br> The i-th column is returned as a Vector4. i must be from 1 to 4 inclusive.
--- @param index number The i-th column. Must be from 1 to 4 inclusive!
--- @return Vector4 # The i-th column
function Matrix4x4.GetColumn(index) end

--- ##### Method
--- ***
--- Returns a row of the matrix.
--- @param index number The i-th row. Must be from 1 to 4 inclusive!
--- @return Vector4 # The i-th row is returned as a Vector4
function Matrix4x4.GetRow(index) end

--- ##### Method
--- ***
--- Transforms a position by this matrix (generic).
--- @param point Vector3 point
--- @return Vector3 # Position v transformed by the current fully arbitrary matrix
function Matrix4x4.MultiplyPoint(point) end

--- ##### Method
--- ***
--- Transforms a position by this matrix (fast).
--- @param  point Vector3  point
--- @return Vector3 # position v transformed by the current transformation matrix
function Matrix4x4.MultiplyPoint3x4( point) end

--- ##### Method
--- ***
--- Transforms a direction by this matrix.
--- @param vector Vector3 direction
--- @return Vector3 # transformed direction by matrix
function Matrix4x4.MultiplyVector(vector) end

--- ##### Method
--- ***
--- Sets a column of the matrix.
--- @param index number The index of the column. Must be 1 to 4 inclusive. 
--- @param column Vector4 column to be set
function Matrix4x4.SetColumn(index, column) end

--- ##### Method
--- ***
--- Sets a row of the matrix.
--- @param index number The i-th row is set from v. i must be from 1 to 4 inclusive.
--- @param row Vector4 The row to be set
function Matrix4x4.SetRow(index, row) end

--- ##### Method
--- ***
--- Returns a plane that is transformed in space.
--- @param plane Plane plane
--- @return Plane # plane that is transformed in space.
function Matrix4x4.TransformPlane(plane) end

--- ##### Method
--- ***
--- Checks if this matrix is a valid transform matrix.
--- @return boolean #  True if this matrix is a valid transform matrix.
function Matrix4x4.ValidTRS() end

--- ##### Static Method
--- ***
--- This function returns a projection matrix with viewing frustum that has a near plane defined by the coordinates that were passed in.
--- @param left number The X coordinate of the left side of the near projection plane in view space.
--- @param right number The X coordinate of the right side of the near projection plane in view space.
--- @param bottom number The Y coordinate of the bottom side of the near projection plane in view space.
--- @param top number The Y coordinate of the top side of the near projection plane in view space.
--- @param zNear number Z distance to the near plane from the origin in view space.
--- @param zFar number Z distance to the far plane from the origin in view space.
--- @return Matrix4x4 # A projection matrix with a viewing frustum defined by the plane coordinates passed in.
function Matrix4x4:Frustum(left, right, bottom, top, zNear, zFar) end

--- ##### Static Method
--- ***
--- This function returns a projection matrix with viewing frustum that has a near plane defined by the coordinates that were passed in.
--- @param frustumPlanes FrustumPlanes Frustum planes struct that contains the view space coordinates of that define a viewing frustum.
--- @return Matrix4x4 # A projection matrix with a viewing frustum defined by the plane coordinates passed in.
function Matrix4x4:Frustum(frustumPlanes) end

--- ##### Static Method
--- ***
--- Computes the inverse of a 3D affine matrix.
--- @param input Matrix4x4 Input matrix to invert.
--- @return boolean # Returns true and a valid result if the function succeeds, false and a copy of the input matrix if the function fails.
--- @return Matrix4x4 # The result of the inversion. Equal to the input matrix if the function fails.
function Matrix4x4:Inverse3DAffine(input) end

--- ##### Static Method
--- ***
--- Create a "look at" matrix.
--- @param from Vector3 The source point.
--- @param to Vector3 The target point.
--- @param up Vector3 The vector describing the up direction (typically `Vector3.up`).
--- @return Matrix4x4 # The resulting transformation matrix.
function Matrix4x4:LookAt(from, to, up) end

--- ##### Static Method
--- ***
--- Create an orthogonal projection matrix.
--- @param left number Left-side x-coordinate.
--- @param right number Right-side x-coordinate.
--- @param bottom number Bottom y-coordinate.
--- @param top number Top y-coordinate.
--- @param zNear number Near depth clipping plane value.
--- @param zFar number Far depth clipping plane value.
--- @return Matrix4x4 # The projection matrix.
function Matrix4x4:Ortho(left, right, bottom, top, zNear, zFar) end

--- ##### Static Method
--- ***
--- Create a perspective projection matrix.
--- @param fov number Vertical field-of-view in degrees.
--- @param aspect number Aspect ratio (width divided by height).
--- @param zNear number Near depth clipping plane value.
--- @param zFar number Far depth clipping plane value.
--- @return Matrix4x4 # The projection matrix.
function Matrix4x4:Perspective(fov, aspect, zNear, zFar) end

--- ##### Static Method
--- ***
--- Creates a rotation matrix.
--- @param q Quaternion Rotation 
--- @return Matrix4x4 # rotation matrix.
function Matrix4x4:Rotate(q) end

--- ##### Static Method
--- ***
--- Creates a scaling matrix.
--- @param vector Vector3 Scale vector
--- @return Matrix4x4 # scaling matrix
function Matrix4x4:Scale(vector) end

--- ##### Static Method
--- ***
--- Creates a translation matrix.
--- @param vector Vector3 vector
--- @return Matrix4x4 # translation matrix.
function Matrix4x4:Translate(vector) end

--- ##### Static Method
--- ***
--- Creates a translation, rotation and scaling matrix.
--- @param pos Vector3 position
--- @param q Quaternion Rotation
--- @param s Vector3 Scale
--- @return Matrix4x4 # translation, rotation and scaling matrix.
function Matrix4x4:TRS(pos, q, s) end

--- ##### Type *MIDI*
--- ***
--- Allows to send and receive MIDI messages. 
--- @class MIDI
--- @field InboundMIDIEnabled boolean **Static**  **Read-Only**  |  Is the inbound MIDI communication enabled with a device. 
--- @field OnReceivedMIDI MIDIOnReceivedMIDIEventHandler **Event** **Static** | Fires when a MIDI message is received. 
--- @field OutboundMIDIEnabled boolean **Static**  **Read-Only**  |  Is the outbound MIDI communication enabled with a device.
MIDI = {}

--- ##### Static Method
--- ***
--- Send a MIDI message. 
--- @param message MIDIMessage The message to be sent.
function MIDI:SendMIDI(message) end

--- ##### Static Method
--- ***
--- Create and send a MIDI message.
--- @param _function MIDIFunction MIDI function.
--- @param channel number The MIDI channel [0-15]
--- @param data1 number Data1 byte [0-127]
--- @param data2 number Data2 byte [0-127] 
function MIDI:SendMIDI(_function, channel, data1, data2) end

--- ##### Static Method
--- ***
--- Send a MIDI Note-Off message. 
--- @param channel number The MIDI channel [0-15]
--- @param note number The Note, [0-127]
--- @param velocity number The note velocity [0-127]
function MIDI:SendNoteOff(channel, note, velocity) end

--- ##### Static Method
--- ***
--- Send a MIDI Note-On Message.
--- @param channel number The MIDI channel [0-15]
--- @param note number The Note, [0-127]
--- @param velocity number The note velocity [0-127]
function MIDI:SendNoteOn(channel, note, velocity) end

--- ##### Type
--- ***
--- Event Handler
--- @class MIDIOnReceivedMIDIEventHandler : EventHandler
MIDIOnReceivedMIDIEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun(message : MIDIMessage)  Function to registered
function MIDIOnReceivedMIDIEventHandler.Add(handler)end

--- ##### Type *MIDIMessage*
--- ***
--- MIDI messages are used by MIDI devices to communicate with each other. MIDIMessage represents a single MIDI message. A MIDI message contains information about the Function, Channel and two data bytes. 
--- @class MIDIMessage
--- @field Channel number The message’s target channel. [0-15] 
--- @field Data1 number First Data byte. [0-127]
--- @field Data2 number Second Data byte. [0-127]
--- @field Function MIDIFunction The message’s MIDI function.
MIDIMessage = {}

--- ##### Constructor for *MIDIMessage*
--- ***
--- Creates a new MIDI message.
--- @param _function MIDIFunction MIDI function. 
--- @param channel number The channel number. [0-15]
--- @param data1 number First Data. [0-127]
--- @param data2 number Second Data. [0-127]
--- @return MIDIMessage
function MIDIMessage(_function, channel, data1, data2) end

--- ##### Constructor for *MIDIMessage*
--- ***
--- Creates a new MIDI message.
--- @return MIDIMessage
function MIDIMessage() end

--- ##### Type *MLAudioChannelPolicy*
--- ***
--- Type describing the audio settings for an in-room audio channel.  
--- @class MLAudioChannelPolicy
--- @field MaxDistance number The maximum distance which a player in the channel can be heard. [0-inf]
--- @field MinDistance number The minimum distance which a player in the channel can be heard. [0-inf]
--- @field SpatialBlend number Similar to spatialBlend in audio source, the value defines if the audio is 2D (SpatialBlend=0) or 3D (SpatialBlend=1) [0-1]
--- @field Volume number The volume of the audio. [0-1]
MLAudioChannelPolicy = {}

--- ##### Constructor for *MLAudioChannelPolicy*
--- ***
--- Creates a new MLAudioChannelPolicy
--- @return MLAudioChannelPolicy
function MLAudioChannelPolicy() end

--- ##### Constructor for *MLAudioChannelPolicy*
--- ***
--- Creates a new MLAudioChannelPolicy
--- @param volume number The volume
--- @param spatialBlend number Spatial Blend
--- @param minDistance number minDistance
--- @param maxDistance number maxDistance
--- @return MLAudioChannelPolicy
function MLAudioChannelPolicy(volume, spatialBlend, minDistance, maxDistance) end

--- ##### Type *MLClickable* inherits *Component*
--- ***
--- MLClickable component’s Lua interface. Attaching this component makes objects clickable by player.
--- @class MLClickable
--- @field OnClick MLClickableOnClickEventHandler **Event**  | Event which will trigger when player clicks the object.
--- @field OnPointerEnter MLClickableOnPointerEnterEventHandler **Event**  | Event which will trigger when player’s pointer starts hovering over the object.
--- @field OnPointerExit MLClickableOnPointerExitEventHandler **Event**  | Event which will trigger when player’s pointer stops hovering over the object. 
--- @field ShowText boolean Shows a text when player hover over the object.
--- @field Text string The text to be shown when player hovers over the object.  
--- @field gameObject GameObject **Read-Only**  **Inherited**  |  The game object this component is attached to. A component is always attached to a game object.
--- @field tag string **Read-Only**  **Inherited**  |  The tag of this game object.
--- @field transform Transform **Read-Only**  **Inherited**  |  The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
MLClickable = {}

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object or any of its children.
--- @param methodName string Name of the method to call.
--- @param parameter any? **Optional**(default = nil) Optional parameter to pass to the method (can be any value).
function MLClickable.BroadcastMessage(methodName, parameter) end

--- ##### Method Inherited from *Component*
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function MLClickable.CompareTag(tag) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # Array of all Lua scripts that attached to the game object.
function MLClickable.GetAllLuaScripts() end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type if the game object has one attached, nil if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # the component of Type type
function MLClickable.GetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function MLClickable.GetComponentInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function MLClickable.GetComponentInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function MLClickable.GetComponents(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function MLClickable.GetComponentsInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function MLClickable.GetComponentsInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object. 
--- @param methodName string Name of the method to call.
--- @param value any? **Optional**(default = nil) Optional parameter for the method.
function MLClickable.SendMessage(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every LuaScript in this game object and on every ancestor of the behaviour.
--- @param methodName string Name of method to call.
--- @param value any? **Optional**(default = nil) Optional parameter value for the method.
function MLClickable.SendMessageUpwards(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of the component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or nil.
function MLClickable.TryGetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function MLClickable.GetInstanceID() end

--- ##### Type
--- ***
--- Event Handler
--- @class MLClickableOnClickEventHandler : EventHandler
MLClickableOnClickEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun(player : MLPlayer)  Function to registered
function MLClickableOnClickEventHandler.Add(handler)end

--- ##### Type
--- ***
--- Event Handler
--- @class MLClickableOnPointerEnterEventHandler : EventHandler
MLClickableOnPointerEnterEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun()  Function to registered
function MLClickableOnPointerEnterEventHandler.Add(handler)end

--- ##### Type
--- ***
--- Event Handler
--- @class MLClickableOnPointerExitEventHandler : EventHandler
MLClickableOnPointerExitEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun()  Function to registered
function MLClickableOnPointerExitEventHandler.Add(handler)end

--- ##### Type *MLGrab* inherits *Component*
--- ***
--- API for MLGrab component. You can use this API to create your own grab mechanics or implement extra functionality to grabbing in Massive Loop. 
--- @class MLGrab
--- @field CurrentUser MLPlayer **Read-Only**  |  Current player who is grabbing the object. Nil if no one is holding to the object.
--- @field ExpectedObjectPosition Vector3 **Read-Only**  |  The calculated, expected position of the grabbed object based on the players hands and grab points using the default grab mechanics.  
--- @field ExpectedObjectRotation Quaternion **Read-Only**  |  The calculated, expected rotation of the grabbed object based on the players hands and grab points using the default grab mechanics.  
--- @field OnPrimaryGrabBegin MLGrabOnPrimaryGrabBeginEventHandler **Event**  | The Event handler which gets invoked when the object is grabbed by the primary hand. This event is invoked in all the clients if the grabbable object synchronized through the MLSynchronizer component.
--- @field OnPrimaryGrabEnd MLGrabOnPrimaryGrabEndEventHandler **Event**  | The Event handler which gets invoked when the object is released by the primary hand. This event is invoked in all the clients if the grabbable object synchronized through the MLSynchronizer component. 
--- @field OnPrimaryTriggerDown MLGrabOnPrimaryTriggerDownEventHandler **Event**  | The Event handler which gets invoked when the triggered button pressed down for the primary hand. This event is invoked in all the clients if the grabbable object synchronized through the MLSynchronizer component. 
--- @field OnPrimaryTriggerDownLocal MLGrabOnPrimaryTriggerDownLocalEventHandler **Event**  | Similar to the `OnPrimaryTriggerDown` which gets invoked with the trigger button pressed down for the primary hand, however, this event handler only gets invoked if the local player is performing this action. 
--- @field OnPrimaryTriggerUp MLGrabOnPrimaryTriggerUpEventHandler **Event**  | The Event handler which gets invoked when the triggered button released for the primary hand. This event is invoked in all the clients if the grabbable object synchronized through the MLSynchronizer component. 
--- @field OnPrimaryTriggerUpLocal MLGrabOnPrimaryTriggerUpLocalEventHandler **Event**  | Similar to the `OnPrimaryTriggeUp` which gets invoked with the trigger button released for the primary hand, however, this event handler only gets invoked if the local player is performing this action.
--- @field OnSecondaryGrabBegin MLGrabOnSecondaryGrabBeginEventHandler **Event**  | The Event handler which gets invoked when the object is grabbed by the secondary hand. This event is invoked in all the clients if the grabbable object synchronized through the MLSynchronizer component. 
--- @field OnSecondaryGrabEnd MLGrabOnSecondaryGrabEndEventHandler **Event**  | The Event handler which gets invoked when the object is released by the secondary hand. This event is invoked in all the clients if the grabbable object synchronized through the MLSynchronizer component. 
--- @field OnSecondaryTriggerDown MLGrabOnSecondaryTriggerDownEventHandler **Event**  | The Event handler which gets invoked when the triggered button pressed down for the secondary hand. This event is invoked in all the clients if the grabbable object synchronized through the MLSynchronizer component. 
--- @field OnSecondaryTriggerDownLocal MLGrabOnSecondaryTriggerDownLocalEventHandler **Event**  | Similar to the `OnSecondaryTriggerDown` which gets invoked with the trigger button pressed down for the secondary hand, however, this event handler only gets invoked if the local player is performing this action. 
--- @field OnSecondaryTriggerUp MLGrabOnSecondaryTriggerUpEventHandler **Event**  | The Event handler which gets invoked when the triggered button released for the secondary hand. This event is invoked in all the clients if the grabbable object synchronized through the MLSynchronizer component. 
--- @field OnSecondaryTriggerUpLocal MLGrabOnSecondaryTriggerUpLocalEventHandler **Event**  | Similar to the `OnSecondaryTriggerUp` which gets invoked with the trigger button released for the secondary hand, however, this event handler only gets invoked if the local player is performing this action. 
--- @field PrimaryGrabPoint Transform **Read-Only**  |  The transform the of the current Primary grab point. Can be used to create a custom grab mechanics.
--- @field PrimaryHand Transform **Read-Only**  |  The transform the of the current player’s primary hand. Can be used to create a custom grab mechanics. 
--- @field SecondaryGrabPoint Transform **Read-Only**  |  The transform the of the current Secondary grab point. Can be used to create a custom grab mechanics.
--- @field SecondaryHand Transform **Read-Only**  |  The transform the of the current player’s secondary hand. Can be used to create a custom grab mechanics. 
--- @field gameObject GameObject **Read-Only**  **Inherited**  |  The game object this component is attached to. A component is always attached to a game object.
--- @field tag string **Read-Only**  **Inherited**  |  The tag of this game object.
--- @field transform Transform **Read-Only**  **Inherited**  |  The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
MLGrab = {}

--- ##### Method
--- ***
--- Captures some of the user input to be used while the object is grabbed by local user. The default actions bind to captured controls disabled until the input released. The Input can be released by calling Release input, or dropping object automatically releases the input. 
--- @return HandInput # Captured hand input. Nil if the local player was not grabbing it. 
function MLGrab.CaptureInput() end

--- ##### Method
--- ***
--- Force releases the object if it is grabbed. 
function MLGrab.ForceRelease() end

--- ##### Method
--- ***
--- Releases the captured input back to normal function. 
function MLGrab.ReleaseInput() end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object or any of its children.
--- @param methodName string Name of the method to call.
--- @param parameter any? **Optional**(default = nil) Optional parameter to pass to the method (can be any value).
function MLGrab.BroadcastMessage(methodName, parameter) end

--- ##### Method Inherited from *Component*
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function MLGrab.CompareTag(tag) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # Array of all Lua scripts that attached to the game object.
function MLGrab.GetAllLuaScripts() end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type if the game object has one attached, nil if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # the component of Type type
function MLGrab.GetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function MLGrab.GetComponentInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function MLGrab.GetComponentInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function MLGrab.GetComponents(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function MLGrab.GetComponentsInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function MLGrab.GetComponentsInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object. 
--- @param methodName string Name of the method to call.
--- @param value any? **Optional**(default = nil) Optional parameter for the method.
function MLGrab.SendMessage(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every LuaScript in this game object and on every ancestor of the behaviour.
--- @param methodName string Name of method to call.
--- @param value any? **Optional**(default = nil) Optional parameter value for the method.
function MLGrab.SendMessageUpwards(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of the component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or nil.
function MLGrab.TryGetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function MLGrab.GetInstanceID() end

--- ##### Type
--- ***
--- Event Handler
--- @class MLGrabOnPrimaryGrabBeginEventHandler : EventHandler
MLGrabOnPrimaryGrabBeginEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun()  Function to registered
function MLGrabOnPrimaryGrabBeginEventHandler.Add(handler)end

--- ##### Type
--- ***
--- Event Handler
--- @class MLGrabOnPrimaryGrabEndEventHandler : EventHandler
MLGrabOnPrimaryGrabEndEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun()  Function to registered
function MLGrabOnPrimaryGrabEndEventHandler.Add(handler)end

--- ##### Type
--- ***
--- Event Handler
--- @class MLGrabOnPrimaryTriggerDownEventHandler : EventHandler
MLGrabOnPrimaryTriggerDownEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun()  Function to registered
function MLGrabOnPrimaryTriggerDownEventHandler.Add(handler)end

--- ##### Type
--- ***
--- Event Handler
--- @class MLGrabOnPrimaryTriggerDownLocalEventHandler : EventHandler
MLGrabOnPrimaryTriggerDownLocalEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun()  Function to registered
function MLGrabOnPrimaryTriggerDownLocalEventHandler.Add(handler)end

--- ##### Type
--- ***
--- Event Handler
--- @class MLGrabOnPrimaryTriggerUpEventHandler : EventHandler
MLGrabOnPrimaryTriggerUpEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun()  Function to registered
function MLGrabOnPrimaryTriggerUpEventHandler.Add(handler)end

--- ##### Type
--- ***
--- Event Handler
--- @class MLGrabOnPrimaryTriggerUpLocalEventHandler : EventHandler
MLGrabOnPrimaryTriggerUpLocalEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun()  Function to registered
function MLGrabOnPrimaryTriggerUpLocalEventHandler.Add(handler)end

--- ##### Type
--- ***
--- Event Handler
--- @class MLGrabOnSecondaryGrabBeginEventHandler : EventHandler
MLGrabOnSecondaryGrabBeginEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun()  Function to registered
function MLGrabOnSecondaryGrabBeginEventHandler.Add(handler)end

--- ##### Type
--- ***
--- Event Handler
--- @class MLGrabOnSecondaryGrabEndEventHandler : EventHandler
MLGrabOnSecondaryGrabEndEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun()  Function to registered
function MLGrabOnSecondaryGrabEndEventHandler.Add(handler)end

--- ##### Type
--- ***
--- Event Handler
--- @class MLGrabOnSecondaryTriggerDownEventHandler : EventHandler
MLGrabOnSecondaryTriggerDownEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun()  Function to registered
function MLGrabOnSecondaryTriggerDownEventHandler.Add(handler)end

--- ##### Type
--- ***
--- Event Handler
--- @class MLGrabOnSecondaryTriggerDownLocalEventHandler : EventHandler
MLGrabOnSecondaryTriggerDownLocalEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun()  Function to registered
function MLGrabOnSecondaryTriggerDownLocalEventHandler.Add(handler)end

--- ##### Type
--- ***
--- Event Handler
--- @class MLGrabOnSecondaryTriggerUpEventHandler : EventHandler
MLGrabOnSecondaryTriggerUpEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun()  Function to registered
function MLGrabOnSecondaryTriggerUpEventHandler.Add(handler)end

--- ##### Type
--- ***
--- Event Handler
--- @class MLGrabOnSecondaryTriggerUpLocalEventHandler : EventHandler
MLGrabOnSecondaryTriggerUpLocalEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun()  Function to registered
function MLGrabOnSecondaryTriggerUpLocalEventHandler.Add(handler)end

--- ##### Type *MLMicrophone* inherits *Component*
--- ***
--- API for MLMicrophone component. MLMicrophone allows to create a live audio binding between Massive Loop MLPlayers audio and AudioSources through MLSpeaker component. Basically, a Microphone and Speaker setup for players. A single Microphone can handle input from multiple players and pipe it to multiple speakers.  
--- @class MLMicrophone
--- @field Active boolean Is microphone active? 
--- @field gameObject GameObject **Read-Only**  **Inherited**  |  The game object this component is attached to. A component is always attached to a game object.
--- @field tag string **Read-Only**  **Inherited**  |  The tag of this game object.
--- @field transform Transform **Read-Only**  **Inherited**  |  The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
MLMicrophone = {}

--- ##### Method
--- ***
--- Bind a new speaker to the microphone. Wont effect anything if the speaker is already bound.
--- @param newSpeaker MLSpeaker The speaker to add. 
function MLMicrophone.AddSpeaker(newSpeaker) end

--- ##### Method
--- ***
--- Returns an array of currently bound Speakers.
--- @return MLSpeaker[] # array of currently bound MLSpeakers
function MLMicrophone.GetSpeakers() end

--- ##### Method
--- ***
--- Remove a currently bound speaker. 
--- @param speaker MLSpeaker The speaker to be removed.
function MLMicrophone.RemoveSpeaker(speaker) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object or any of its children.
--- @param methodName string Name of the method to call.
--- @param parameter any? **Optional**(default = nil) Optional parameter to pass to the method (can be any value).
function MLMicrophone.BroadcastMessage(methodName, parameter) end

--- ##### Method Inherited from *Component*
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function MLMicrophone.CompareTag(tag) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # Array of all Lua scripts that attached to the game object.
function MLMicrophone.GetAllLuaScripts() end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type if the game object has one attached, nil if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # the component of Type type
function MLMicrophone.GetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function MLMicrophone.GetComponentInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function MLMicrophone.GetComponentInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function MLMicrophone.GetComponents(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function MLMicrophone.GetComponentsInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function MLMicrophone.GetComponentsInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object. 
--- @param methodName string Name of the method to call.
--- @param value any? **Optional**(default = nil) Optional parameter for the method.
function MLMicrophone.SendMessage(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every LuaScript in this game object and on every ancestor of the behaviour.
--- @param methodName string Name of method to call.
--- @param value any? **Optional**(default = nil) Optional parameter value for the method.
function MLMicrophone.SendMessageUpwards(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of the component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or nil.
function MLMicrophone.TryGetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function MLMicrophone.GetInstanceID() end

--- ##### Type *MLMirror* inherits *Component*
--- ***
--- API for MLMirror component.
--- @class MLMirror
--- @field MirrorActive boolean Is the mirror active. You can enable or disable the mirror using this property. 
--- @field gameObject GameObject **Read-Only**  **Inherited**  |  The game object this component is attached to. A component is always attached to a game object.
--- @field tag string **Read-Only**  **Inherited**  |  The tag of this game object.
--- @field transform Transform **Read-Only**  **Inherited**  |  The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
MLMirror = {}

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object or any of its children.
--- @param methodName string Name of the method to call.
--- @param parameter any? **Optional**(default = nil) Optional parameter to pass to the method (can be any value).
function MLMirror.BroadcastMessage(methodName, parameter) end

--- ##### Method Inherited from *Component*
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function MLMirror.CompareTag(tag) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # Array of all Lua scripts that attached to the game object.
function MLMirror.GetAllLuaScripts() end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type if the game object has one attached, nil if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # the component of Type type
function MLMirror.GetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function MLMirror.GetComponentInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function MLMirror.GetComponentInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function MLMirror.GetComponents(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function MLMirror.GetComponentsInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function MLMirror.GetComponentsInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object. 
--- @param methodName string Name of the method to call.
--- @param value any? **Optional**(default = nil) Optional parameter for the method.
function MLMirror.SendMessage(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every LuaScript in this game object and on every ancestor of the behaviour.
--- @param methodName string Name of method to call.
--- @param value any? **Optional**(default = nil) Optional parameter value for the method.
function MLMirror.SendMessageUpwards(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of the component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or nil.
function MLMirror.TryGetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function MLMirror.GetInstanceID() end

--- ##### Type *MLPlayer*
--- ***
--- Represents the Massive Loop Player and its properties.
--- @class MLPlayer
--- @field ActorID number **Read-Only**  |  Unique ID given to the player in room. Note that this id is only persistent during the session.
--- @field AvatarTrackedObject GameObject **Read-Only**  |  Avatar tracked object is a game object which is tracked by the VR camera. This means that this object is located where the player camera is.
--- @field CurrentAvatarGuid string **Read-Only**  |  The Guid of the players current avatar (read-only).
--- @field Guid string **Read-Only**  |  A unique and persistent GUID representing the the Massive Loop player. This ID will remain perpetually persistent between different sessions. 
--- @field Health number Predefined Health property of the player. It is synchronized between all clients in the room. Note that it is not defined by default.
--- @field IsGrounded boolean **Read-Only**  |  True if the players avatar is grounded, i.e., touching ground. 
--- @field isLocal boolean **Read-Only**  |  Is this player the local player? Local to the script which is retrieving this value. 
--- @field isMasterClient boolean **Read-Only**  |  Is this player a MasterClient? Check out [this article]( https://sdk.massiveloop.com/getting_started/scripting/multiplayer.html) to know more about concept of master client.
--- @field Locomotion PlayerLocomotion **Read-Only**  |  Player’s locomotion controls. You can modify the locomotion values and types using this class. Only on local player.
--- @field NetworkID number **Read-Only**  |  Unique Network ID given to the player. It is not a persistent ID and subject to change during the session.
--- @field NickName string **Read-Only**  |  A non-unique name of the player.
--- @field OnTransmissionChannelUpdate MLPlayerOnTransmissionChannelUpdateEventHandler **Event**  | Called when transmission channels get updated on the server.
--- @field PlayerRoot GameObject **Read-Only**  |  The Root GameObject of the player.
--- @field Score number Predefined Score property of the Player. It is synchronized between all clients in the room. Note that it is not defined by default. 
MLPlayer = {}

--- ##### Method
--- ***
--- Gets the player’s current gravity value.
--- @return number # Player’s current gravity value.
function MLPlayer.GetGravity() end

--- ##### Method
--- ***
--- Returns the value of the custom property. Returns nil in case if the property does not exist or the value is invalid. Use `PropertyExists(key)` function to check if the property is defined. It might take some time before for newly defined property to propagate between all clients.  
--- @param key string The name of the property.
--- @return any # The value of the property
function MLPlayer.GetProperty(key) end

--- ##### Method
--- ***
--- Send player to another world. This method only take effect if player is the local player. Note that this method also will not work in Local Mode. 
--- @param worldGuid string The id of the target world defined in GUID (globally unique id). You can use the world browser in massive loop website to find the GUID of any world, including the built-in worlds.
--- @param region string The region token of the target instance. Set it to nil for best region or use on of the region tokens listed below.
--- @param behavior PortalBehavior The behavior of the portal in regard to the instance of the target world. 
--- @param insntanceId string? **Optional**(default = nil) Optional instance id of the target instance if the `PortalBehavior.JoinSpecific` selected. Use this only if you are trying to create a portal to a persistent instance. Note that the instance id of the none-persistent (basically any normal) instance is fluid and will change, destroyed when everybody in that instance leave.
function MLPlayer.Portal(worldGuid, region, behavior, insntanceId) end

--- ##### Method
--- ***
--- Checks if a custom property is defined. This does not guarantee that the value of the property is valid.
--- @param key string the name of the property
--- @return boolean # True if the property is defined.
function MLPlayer.PropertyExists(key) end

--- ##### Method
--- ***
--- Rotates player root by given degree. 
--- @param rotation number rotation angle in degree. 
function MLPlayer.Rotate(rotation) end

--- ##### Method
--- ***
--- Set the avatar for the current avatar. Note that this function only works for local player, and it always shows a prompt for user to allow changing avatar. You can use `CurrentAvatarGuid` property to check if player have the avatar you desire. 
--- @param guid string The Guid of the desired Avatar. The Function will throw argument exception if this value is empty or doesn’t point to an avatar on server. 
function MLPlayer.SetAvatar(guid) end

--- ##### Method
--- ***
--- Sets the players gravity value. This value changes the gravitational forces applied to the player. Use SetGravityAxis To set the gravitational directions. The value must be between [-50,50]. Default value is -10.
--- @param gravityValue number New gravity value. Must between -50 and 50.
function MLPlayer.SetGravity(gravityValue) end

--- ##### Method
--- ***
--- Set the gravity axis of the player.
--- @param axis Vector3 Gravity axis
--- @param relativeToPlayer boolean If true, the given gravity direction applied as relative to player. If false, it will be applied as global direction1. 
function MLPlayer.SetGravityAxis(axis, relativeToPlayer) end

--- ##### Method
--- ***
--- Sets the player heading. Heading is defined by Z+ axis being the 0 degree and increasing in clockwise.  
--- @param heading number heading in degrees. 
function MLPlayer.SetHeading(heading) end

--- ##### Method
--- ***
--- Sets a custom property to the player. Custom properties are synchronized between the clients. Make sure the property type is serializable. Check out serializable types [here]( https://sdk.massiveloop.com/getting_started/scripting/SerializableTypes.html)
--- @param key string The name of the property. Use this key to retrieve the property. Must be unique.
--- @param value any The Value to set. Must be serializable for proper synchronization. 
--- @return boolean # True if setting the property was successful.
function MLPlayer.SetProperty(key, value) end

--- ##### Method
--- ***
--- Teleports the player root to the desired location.
--- @param location Vector3 Where the player will be teleported.
function MLPlayer.Teleport(location) end

--- ##### Method
--- ***
--- Clears the player receiver channels.
--- @return boolean # true if the operation could be send to the server, otherwise false.
function MLPlayer.TryClearReceiverChannels() end

--- ##### Method
--- ***
--- Clears the player transmission channels.
--- @return boolean # true if the operation could be send to the server, otherwise false.
function MLPlayer.TryClearTransmissionChannels() end

--- ##### Method
--- ***
--- Gets the player receiver channels.
--- @return boolean # return true if able to get the receiver channels, otherwise false.
--- @return number[] # Receiver channels.
function MLPlayer.TryGetReceiverChannels() end

--- ##### Method
--- ***
--- Gets the transmission channels.
--- @return boolean # return true if able to get the transmission channels, otherwise false.
--- @return number[] # Transmission channels.
function MLPlayer.TryGetTransmissionChannels() end

--- ##### Method
--- ***
--- Update receiving channel of the local client.
--- @param channelsToRemove number[] Channels to unsubscibe from receiving. Null will not remove any.
--- @param channelsToAdd number[] Channel to subscribe to receiver. Null will not add any.
--- @return boolean # return true if operation succeed, otherwise false.
function MLPlayer.UpdateReceiverChannels(channelsToRemove, channelsToAdd) end

--- ##### Method
--- ***
--- Update transmission channel of the local client.
--- @param channelsToRemove number[] Channels to unsubscribe from transmission. Nil will not remove any.
--- @param channelsToAdd number[] Channels to subscribe to transmission. Nil will not add any.
--- @return boolean # bool return true if operation could be send to the server, otherwise false. Also returns
function MLPlayer.UpdateTransmissionChannels(channelsToRemove, channelsToAdd) end

--- ##### Type
--- ***
--- Event Handler
--- @class MLPlayerOnTransmissionChannelUpdateEventHandler : EventHandler
MLPlayerOnTransmissionChannelUpdateEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun(actorNo : number, transmissionChannels : number)  Function to registered
function MLPlayerOnTransmissionChannelUpdateEventHandler.Add(handler)end

--- ##### Type *MLSpeaker* inherits *Component*
--- ***
--- API for MLSpeaker component. MLSpeaker receives audio data from microphone to be played. 
--- @class MLSpeaker
--- @field SpeakerActive boolean Is the speaker active? 
--- @field gameObject GameObject **Read-Only**  **Inherited**  |  The game object this component is attached to. A component is always attached to a game object.
--- @field tag string **Read-Only**  **Inherited**  |  The tag of this game object.
--- @field transform Transform **Read-Only**  **Inherited**  |  The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
MLSpeaker = {}

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object or any of its children.
--- @param methodName string Name of the method to call.
--- @param parameter any? **Optional**(default = nil) Optional parameter to pass to the method (can be any value).
function MLSpeaker.BroadcastMessage(methodName, parameter) end

--- ##### Method Inherited from *Component*
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function MLSpeaker.CompareTag(tag) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # Array of all Lua scripts that attached to the game object.
function MLSpeaker.GetAllLuaScripts() end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type if the game object has one attached, nil if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # the component of Type type
function MLSpeaker.GetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function MLSpeaker.GetComponentInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function MLSpeaker.GetComponentInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function MLSpeaker.GetComponents(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function MLSpeaker.GetComponentsInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function MLSpeaker.GetComponentsInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object. 
--- @param methodName string Name of the method to call.
--- @param value any? **Optional**(default = nil) Optional parameter for the method.
function MLSpeaker.SendMessage(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every LuaScript in this game object and on every ancestor of the behaviour.
--- @param methodName string Name of method to call.
--- @param value any? **Optional**(default = nil) Optional parameter value for the method.
function MLSpeaker.SendMessageUpwards(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of the component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or nil.
function MLSpeaker.TryGetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function MLSpeaker.GetInstanceID() end

--- ##### Type *MLStation* inherits *Component*
--- ***
--- MLStation component provides a mean to attach players to another object. The most common use for this is creating a seat. When attached to the station, the player loses its movement abilities, but still can move their head and hands. Using the Lua, the player controller inputs can be accessed and used to drive vehicles.
--- @class MLStation
--- @field IsOccupied boolean True if there is a player attached to the station. (Read only)
--- @field Lock boolean Sets or gets the station lock. If the station is locked, the players cannot enter or exit the station. While locked, a player still can be attached or detached to the station using Lua script. 
--- @field OnPlayerLeft MLStationOnPlayerLeftEventHandler **Event**  | Event that triggers when a player leaves (detaches) the station. 
--- @field OnPlayerSeated MLStationOnPlayerSeatedEventHandler **Event**  | Event that triggers when a player gets attached to the station.
--- @field gameObject GameObject **Read-Only**  **Inherited**  |  The game object this component is attached to. A component is always attached to a game object.
--- @field tag string **Read-Only**  **Inherited**  |  The tag of this game object.
--- @field transform Transform **Read-Only**  **Inherited**  |  The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
MLStation = {}

--- ##### Method
--- ***
--- Returns the current players controller inputs. Note that this function returns the controller inputs for the local player, so only the client which the current player is local can access the inputs. 
--- @return UserInput # Controller inputs of the current player if it is local for the client. Nil otherwise.
function MLStation.GetInput() end

--- ##### Method
--- ***
--- Gets the MLPlayer object of current station occupant. Returns null if the station is empty.
--- @return MLPlayer # Current player
function MLStation.GetPlayer() end

--- ##### Method
--- ***
--- Removes (detaches) the current player from station if there is any. 
function MLStation.RemovePlayer() end

--- ##### Method
--- ***
--- Attaches the given player to the station. Ignores if the station is occupied.
--- @param player MLPlayer The Player to attach.
function MLStation.SettlePlayer(player) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object or any of its children.
--- @param methodName string Name of the method to call.
--- @param parameter any? **Optional**(default = nil) Optional parameter to pass to the method (can be any value).
function MLStation.BroadcastMessage(methodName, parameter) end

--- ##### Method Inherited from *Component*
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function MLStation.CompareTag(tag) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # Array of all Lua scripts that attached to the game object.
function MLStation.GetAllLuaScripts() end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type if the game object has one attached, nil if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # the component of Type type
function MLStation.GetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function MLStation.GetComponentInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function MLStation.GetComponentInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function MLStation.GetComponents(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function MLStation.GetComponentsInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function MLStation.GetComponentsInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object. 
--- @param methodName string Name of the method to call.
--- @param value any? **Optional**(default = nil) Optional parameter for the method.
function MLStation.SendMessage(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every LuaScript in this game object and on every ancestor of the behaviour.
--- @param methodName string Name of method to call.
--- @param value any? **Optional**(default = nil) Optional parameter value for the method.
function MLStation.SendMessageUpwards(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of the component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or nil.
function MLStation.TryGetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function MLStation.GetInstanceID() end

--- ##### Type
--- ***
--- Event Handler
--- @class MLStationOnPlayerLeftEventHandler : EventHandler
MLStationOnPlayerLeftEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun()  Function to registered
function MLStationOnPlayerLeftEventHandler.Add(handler)end

--- ##### Type
--- ***
--- Event Handler
--- @class MLStationOnPlayerSeatedEventHandler : EventHandler
MLStationOnPlayerSeatedEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun()  Function to registered
function MLStationOnPlayerSeatedEventHandler.Add(handler)end

--- ##### Type *MLStreamingBrowser* inherits *Component*
--- ***
--- API interface to MLStreamingBrowser.
--- @class MLStreamingBrowser
--- @field IsReady boolean **Read-Only**  |  Is the browser fully initialized?
--- @field IsURLStatic boolean **Read-Only**  |  Can the browser URL set in runtime?
--- @field URL string **Read-Only**  |  Current browser URL
--- @field gameObject GameObject **Read-Only**  **Inherited**  |  The game object this component is attached to. A component is always attached to a game object.
--- @field tag string **Read-Only**  **Inherited**  |  The tag of this game object.
--- @field transform Transform **Read-Only**  **Inherited**  |  The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
MLStreamingBrowser = {}

--- ##### Method
--- ***
--- Pass input keyboard input to the browser. Useful for creating interface to a online game, or tool that currently loaded by browser. 
--- @param key string The keyname
--- @param isDown boolean If the key input was down. 
function MLStreamingBrowser.PassInput(key, isDown) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object or any of its children.
--- @param methodName string Name of the method to call.
--- @param parameter any? **Optional**(default = nil) Optional parameter to pass to the method (can be any value).
function MLStreamingBrowser.BroadcastMessage(methodName, parameter) end

--- ##### Method Inherited from *Component*
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function MLStreamingBrowser.CompareTag(tag) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # Array of all Lua scripts that attached to the game object.
function MLStreamingBrowser.GetAllLuaScripts() end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type if the game object has one attached, nil if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # the component of Type type
function MLStreamingBrowser.GetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function MLStreamingBrowser.GetComponentInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function MLStreamingBrowser.GetComponentInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function MLStreamingBrowser.GetComponents(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function MLStreamingBrowser.GetComponentsInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function MLStreamingBrowser.GetComponentsInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object. 
--- @param methodName string Name of the method to call.
--- @param value any? **Optional**(default = nil) Optional parameter for the method.
function MLStreamingBrowser.SendMessage(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every LuaScript in this game object and on every ancestor of the behaviour.
--- @param methodName string Name of method to call.
--- @param value any? **Optional**(default = nil) Optional parameter value for the method.
function MLStreamingBrowser.SendMessageUpwards(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of the component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or nil.
function MLStreamingBrowser.TryGetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function MLStreamingBrowser.GetInstanceID() end

--- ##### Type *MLVideoExtension* inherits *Component*
--- ***
--- This component extends the functionality of the native Unity Video Player and extra functionality. You can use this component to synchronize the position and state of the video across all player in a room. 
--- @class MLVideoExtension
--- @field OnVideoStatusChanged MLVideoExtensionOnVideoStatusChangedEventHandler **Event**  | This event fire when the status of the video changed by other clients in the room. Use if you check the “TryToSynchronizeVideoPosition” in component.
--- @field OnVideoTimeChanged MLVideoExtensionOnVideoTimeChangedEventHandler **Event**  | This event will fire when the time of the video changed by other clients in the room. Use if you check the `TryToSynchronizeVideoPosition` in component. 
--- @field Status VideoStatus **Read-Only**  |  The current status of the video. (Read-only)
--- @field URL string The URL of the video to play. When setting the URL, the video starts to play after load if the component set to player on awake. 
--- @field VideoTime number Current time of the video. You can set the time of the video to play this way. 
--- @field gameObject GameObject **Read-Only**  **Inherited**  |  The game object this component is attached to. A component is always attached to a game object.
--- @field tag string **Read-Only**  **Inherited**  |  The tag of this game object.
--- @field transform Transform **Read-Only**  **Inherited**  |  The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
MLVideoExtension = {}

--- ##### Method
--- ***
--- Jump the video to specified time and start/continue playing. 
--- @param time number The time to jump in seconds.
function MLVideoExtension.Jump(time) end

--- ##### Method
--- ***
--- Pauses the video if it is `Playing`.
function MLVideoExtension.Pause() end

--- ##### Method
--- ***
--- Plays the video if it is `Idle` or `Paused.
function MLVideoExtension.Play() end

--- ##### Method
--- ***
--- Stops the video. 
function MLVideoExtension.Stop() end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object or any of its children.
--- @param methodName string Name of the method to call.
--- @param parameter any? **Optional**(default = nil) Optional parameter to pass to the method (can be any value).
function MLVideoExtension.BroadcastMessage(methodName, parameter) end

--- ##### Method Inherited from *Component*
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function MLVideoExtension.CompareTag(tag) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # Array of all Lua scripts that attached to the game object.
function MLVideoExtension.GetAllLuaScripts() end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type if the game object has one attached, nil if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # the component of Type type
function MLVideoExtension.GetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function MLVideoExtension.GetComponentInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function MLVideoExtension.GetComponentInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function MLVideoExtension.GetComponents(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function MLVideoExtension.GetComponentsInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function MLVideoExtension.GetComponentsInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object. 
--- @param methodName string Name of the method to call.
--- @param value any? **Optional**(default = nil) Optional parameter for the method.
function MLVideoExtension.SendMessage(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every LuaScript in this game object and on every ancestor of the behaviour.
--- @param methodName string Name of method to call.
--- @param value any? **Optional**(default = nil) Optional parameter value for the method.
function MLVideoExtension.SendMessageUpwards(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of the component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or nil.
function MLVideoExtension.TryGetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function MLVideoExtension.GetInstanceID() end

--- ##### Type
--- ***
--- Event Handler
--- @class MLVideoExtensionOnVideoStatusChangedEventHandler : EventHandler
MLVideoExtensionOnVideoStatusChangedEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun()  Function to registered
function MLVideoExtensionOnVideoStatusChangedEventHandler.Add(handler)end

--- ##### Type
--- ***
--- Event Handler
--- @class MLVideoExtensionOnVideoTimeChangedEventHandler : EventHandler
MLVideoExtensionOnVideoTimeChangedEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun()  Function to registered
function MLVideoExtensionOnVideoTimeChangedEventHandler.Add(handler)end

--- ##### Type *Motion* inherits *Object*
--- ***
--- Base class for AnimationClips and BlendTrees.
--- @class Motion
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
Motion = {}

--- ##### Method Inherited from *Object*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function Motion.GetInstanceID() end

--- ##### Type *NavMesh*
--- ***
--- Singleton class to access the baked NavMesh.
--- @class NavMesh
--- @field AllAreas number **Static**  |  Area mask constant that includes all NavMesh areas.
--- @field avoidancePredictionTime number Describes how far in the future the agents predict collisions for avoidance.
--- @field onPreUpdate function **Static**  |  Set a function to be called before the NavMesh is updated during the frame update execution.
--- @field pathfindingIterationsPerFrame number **Static**  |  The maximum number of nodes processed for each frame during the asynchronous pathfinding process.
NavMesh = {}

--- ##### Static Method
--- ***
--- Adds a link to the NavMesh. The link is described by the NavMeshLinkData struct. Returns an instance for the added link.
--- @param link NavMeshLinkData Describing the properties of the link.
--- @return NavMeshLinkInstance # Representing the added link.
function NavMesh:AddLink(link) end

--- ##### Static Method
--- ***
--- Adds a link to the NavMesh. The link is described by the NavMeshLinkData struct. Returns an instance for the added link.
--- @param link NavMeshLinkData Describing the properties of the link.
--- @param position Vector3 Translate the link to this position.
--- @param rotation Quaternion Rotate the link to this orientation.
--- @return NavMeshLinkInstance # Representing the added link.
function NavMesh:AddLink(link, position, rotation) end

--- ##### Static Method
--- ***
--- Adds the specified NavMeshData to the game.
--- @param navMeshData NavMeshData Contains the data for the navmesh.
--- @return NavMeshDataInstance # Representing the added navmesh.
function NavMesh:AddNavMeshData(navMeshData) end

--- ##### Static Method
--- ***
--- Adds the specified NavMeshData to the game.
--- @param navMeshData NavMeshData Contains the data for the navmesh.
--- @param position Vector3 Translate the navmesh to this position.
--- @param rotation Quaternion Rotate the navmesh to this orientation.
--- @return NavMeshDataInstance # Representing the added navmesh.
function NavMesh:AddNavMeshData(navMeshData, position, rotation) end

--- ##### Static Method
--- ***
--- Calculate a path between two points and store the resulting path.
--- @param sourcePosition Vector3 The initial position of the path requested.
--- @param targetPosition Vector3 The final position of the path requested.
--- @param areaMask number A bitfield mask specifying which NavMesh areas can be passed when calculating a path.
--- @return boolean # True if either a complete or partial path is found. False otherwise.
--- @return NavMeshPath # The resulting path.
function NavMesh:CalculatePath(sourcePosition, targetPosition, areaMask) end

--- ##### Static Method
--- ***
--- Calculate a path between two points and store the resulting path.
--- @param sourcePosition Vector3 The initial position of the path requested.
--- @param targetPosition Vector3 The final position of the path requested.
--- @param filter NavMeshQueryFilter A filter specifying the cost of NavMesh areas that can be passed when calculating a path.
--- @return boolean # True if a either a complete or partial path is found and false otherwise.
--- @return NavMeshPath # The resulting path.
function NavMesh:CalculatePath(sourcePosition, targetPosition, filter) end

--- ##### Static Method
--- ***
--- Calculates triangulation of the current navmesh.
--- @return NavMeshTriangulation # triangulation of the current navmesh.
function NavMesh:CalculateTriangulation() end

--- ##### Static Method
--- ***
--- Locate the closest NavMesh edge from a point on the NavMesh.
--- @param sourcePosition Vector3 The origin of the distance query.
--- @param areaMask number A bitfield mask specifying which NavMesh areas can be passed when finding the nearest edge.
--- @return boolean # True if the nearest edge is found.
--- @return NavMeshHit # resulting location.
function NavMesh:FindClosestEdge(sourcePosition, areaMask) end

--- ##### Static Method
--- ***
--- ocate the closest NavMesh edge from a point on the NavMesh, subject to the constraints of the filter argument.
--- @param sourcePosition Vector3 The origin of the distance query.
--- @param filter NavMeshQueryFilter A filter specifying which NavMesh areas can be passed when finding the nearest edge.
--- @return boolean # True if the nearest edge is found.
--- @return NavMeshHit # resulting location
function NavMesh:FindClosestEdge(sourcePosition, filter) end

--- ##### Static Method
--- ***
--- Gets the cost for path finding over geometry of the area type.
--- @param areaIndex number Index of the area to get.
--- @return number # cost for path finding over geometry of the area type.
function NavMesh:GetAreaCost(areaIndex) end

--- ##### Static Method
--- ***
--- Returns the area index for a named NavMesh area type.
--- @param areaName string Name of the area to look up.
--- @return number # Index if the specified are, or -1 if no area found.
function NavMesh:GetAreaFromName(areaName) end

--- ##### Static Method
--- ***
--- Trace a line between two points on the NavMesh.
--- @param sourcePosition Vector3 The origin of the ray.
--- @param targetPosition Vector3 The end of the ray.
--- @param areaMask number A bitfield mask specifying which NavMesh areas can be passed when tracing the ray.
--- @return boolean # True if the ray is terminated before reaching target position. Otherwise returns false.
--- @return NavMeshHit # properties of the ray cast resulting location.
function NavMesh:Raycast(sourcePosition, targetPosition, areaMask) end

--- ##### Static Method
--- ***
--- Traces a line between two positions on the NavMesh, subject to the constraints defined by the filter argument. The line is terminated on outer edges or a non-passable area.
--- @param sourcePosition Vector3 The origin of the ray.
--- @param targetPosition Vector3 The end of the ray.
--- @param filter NavMeshQueryFilter A filter specifying which NavMesh areas can be passed when tracing the ray.
--- @return boolean # True if the ray is terminated before reaching target position. Otherwise returns false.
--- @return NavMeshHit # properties of the ray cast resulting location.
function NavMesh:Raycast(sourcePosition, targetPosition, filter) end

--- ##### Static Method
--- ***
--- Removes all NavMesh surfaces and links from the game.
function NavMesh:RemoveAllNavMeshData() end

--- ##### Static Method
--- ***
--- Removes a link from the NavMesh.
--- @param handle NavMeshLinkInstance The instance of a link to remove.
function NavMesh:RemoveLink(handle) end

--- ##### Static Method
--- ***
--- Removes the specified NavMeshDataInstance from the game, making it unavailable for agents and queries.
--- @param handle NavMeshDataInstance The instance of a NavMesh to remove.
function NavMesh:RemoveNavMeshData(handle) end

--- ##### Static Method
--- ***
--- Finds the nearest point based on the NavMesh within a specified range.
--- @param sourcePosition Vector3 The origin of the sample query.
--- @param maxDistance number Sample within this distance from sourcePosition.
--- @param areaMask number A mask that specifies the NavMesh areas allowed when finding the nearest point.
--- @return boolean # True if the nearest point is found.
--- @return NavMeshHit # Holds the properties of the resulting location. The value of hit.normal is never computed. It is always (0,0,0).
function NavMesh:SamplePosition(sourcePosition, maxDistance, areaMask) end

--- ##### Static Method
--- ***
--- Samples the position nearest the sourcePosition on any NavMesh built for the agent type specified by the filter.  Consider only positions on areas defined in the NavMeshQueryFilter.areaMask. A maximum search radius is set by maxDistance. The information of any found position is returned in the hit argument.
--- @param sourcePosition Vector3 The origin of the sample query.
--- @param maxDistance number Sample within this distance from sourcePosition.
--- @param filter NavMeshQueryFilter A filter specifying which NavMesh areas are allowed when finding the nearest point.
--- @return boolean # True if the nearest point is found.
--- @return NavMeshHit # Holds the properties of the resulting location. The value of hit.normal is never computed. It is always (0,0,0).
function NavMesh:SamplePosition(sourcePosition, maxDistance, filter) end

--- ##### Static Method
--- ***
--- Sets the cost for finding path over geometry of the area type on all agents.
--- @param areaIndex number Index of the area to set.
--- @param cost number New cost.
function NavMesh:SetAreaCost(areaIndex, cost) end

--- ##### Type *NavMeshAgent* inherits *Behaviour*
--- ***
--- Navigation mesh agent.
--- @class NavMeshAgent
--- @field acceleration number The maximum acceleration of an agent as it follows a path, given in units / sec^2.
--- @field agentTypeID number The type ID for the agent.
--- @field angularSpeed number Maximum turning speed in (deg/s) while following a path.
--- @field areaMask boolean Specifies which NavMesh areas are passable.
--- @field autoBraking boolean Should the agent brake automatically to avoid overshooting the destination point?
--- @field autoRepath boolean Should the agent attempt to acquire a new path if the existing path becomes invalid?
--- @field autoTraverseOffMeshLink boolean Should the agent move across OffMeshLinks automatically?
--- @field avoidancePriority number The avoidance priority level.
--- @field baseOffset number The relative vertical displacement of the owning GameObject.
--- @field currentOffMeshLinkData OffMeshLinkData The current OffMeshLinkData.
--- @field desiredVelocity Vector3 The desired velocity of the agent including any potential contribution from avoidance. (Read Only)
--- @field destination Vector3 Gets or attempts to set the destination of the agent in world-space units.
--- @field hasPath boolean Does the agent currently have a path? (Read Only)
--- @field height number The height of the agent for purposes of passing under obstacles, etc. 
--- @field isOnNavMesh boolean Is the agent currently bound to the navmesh? (Read Only)
--- @field isOnOffMeshLink boolean Is the agent currently positioned on an OffMeshLink? (Read Only)
--- @field isPathStale boolean Is the current path stale. (Read Only)
--- @field isStopped boolean This property holds the stop or resume condition of the NavMesh agent.
--- @field navMeshOwner Object Returns the owning object of the NavMesh the agent is currently placed on (Read Only).
--- @field nextOffMeshLinkData OffMeshLinkData The next OffMeshLinkData on the current path.
--- @field nextPosition Vector3 Gets or sets the simulation position of the navmesh agent.
--- @field obstacleAvoidanceType ObstacleAvoidanceType The level of quality of avoidance.
--- @field path NavMeshPath Property to get and set the current path.
--- @field pathPending boolean s a path in the process of being computed but not yet ready? (Read Only)
--- @field pathStatus NavMeshPathStatus The status of the current path (complete, partial or invalid).
--- @field radius number The avoidance radius for the agent.
--- @field remainingDistance number The distance between the agent's position and the destination on the current path. (Read Only)
--- @field speed number Maximum movement speed when following a path.
--- @field steeringTarget Vector3 Get the current steering target along the path. (Read Only)
--- @field stoppingDistance number Stop within this distance from the target position.
--- @field updatePosition boolean Gets or sets whether the transform position is synchronized with the simulated agent position. The default value is true.
--- @field updateRotation boolean Should the agent update the transform orientation?
--- @field updateUpAxis boolean Allows you to specify whether the agent should be aligned to the up-axis of the NavMesh or link that it is placed on.
--- @field velocity Vector3 Access the current velocity of the NavMeshAgent component, or set a velocity to control the agent manually.
--- @field enabled boolean **Inherited**  |  Enabled Behaviours are Updated, disabled Behaviours are not.
--- @field isActiveAndEnabled boolean **Inherited**  |  Has the Behaviour had active and enabled called?
--- @field gameObject GameObject **Read-Only**  **Inherited**  |  The game object this component is attached to. A component is always attached to a game object.
--- @field tag string **Read-Only**  **Inherited**  |  The tag of this game object.
--- @field transform Transform **Read-Only**  **Inherited**  |  The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
NavMeshAgent = {}

--- ##### Method
--- ***
--- Enables or disables the current off-mesh link.
--- @param activated boolean Is the link activated?
function NavMeshAgent.ActivateCurrentOffMeshLink(activated) end

--- ##### Method
--- ***
--- Calculate a path to a specified point and store the resulting path.
--- @param targetPosition Vector3 The final position of the path requested.
--- @param path NavMeshPath The resulting path.
function NavMeshAgent.CalculatePath(targetPosition, path) end

--- ##### Method
--- ***
--- Completes the movement on the current OffMeshLink.
function NavMeshAgent.CompleteOffMeshLink() end

--- ##### Method
--- ***
--- Locate the closest NavMesh edge.
--- @return boolean # True if a nearest edge is found.
--- @return NavMeshHit # properties of the resulting location.
function NavMeshAgent.FindClosestEdge() end

--- ##### Method
--- ***
--- Gets the cost for path calculation when crossing area of a particular type.
--- @param areaIndex number Area Index.
--- @return number # Current cost for specified area index.
function NavMeshAgent.GetAreaCost(areaIndex) end

--- ##### Method
--- ***
--- Apply relative movement to current position.
--- @param offset Vector3 The relative movement vector.
function NavMeshAgent.Move(offset) end

--- ##### Method
--- ***
--- Trace a straight path towards a target postion in the NavMesh without moving the agent.
--- @param targetPosition Vector3 The desired end position of movement.
--- @return boolean # True if there is an obstacle between the agent and the target position, otherwise false.
--- @return NavMeshHit # Properties of the obstacle detected by the ray (if any, nil otherwise).
function NavMeshAgent.Raycast(targetPosition) end

--- ##### Method
--- ***
--- Clears the current path.
function NavMeshAgent.ResetPath() end

--- ##### Method
--- ***
--- Sample a position along the current path.
--- @param areaMask number A bitfield mask specifying which NavMesh areas can be passed when tracing the path.
--- @param maxDistance number Terminate scanning the path at this distance.
--- @return boolean # True if terminated before reaching the position at maxDistance, false otherwise.
--- @return NavMeshHit # the properties of the resulting location.
function NavMeshAgent.SamplePathPosition(areaMask, maxDistance) end

--- ##### Method
--- ***
--- Sets the cost for traversing over areas of the area type.
--- @param areaIndex number Area cost.
--- @param areaCost number New cost for the specified area index.
function NavMeshAgent.SetAreaCost(areaIndex, areaCost) end

--- ##### Method
--- ***
--- Sets or updates the destination thus triggering the calculation for a new path.
--- @param target Vector3 The target point to navigate to.
--- @return boolean # True if the destination was requested successfully, otherwise false.
function NavMeshAgent.SetDestination(target) end

--- ##### Method
--- ***
--- Assign a new path to this agent.
--- @param path NavMeshPath New path to follow.
--- @return boolean # True if the path is succesfully assigned.
function NavMeshAgent.SetPath(path) end

--- ##### Method
--- ***
--- Warps agent to the provided position.
--- @param newPosition Vector3 New position to warp the agent to.
--- @return boolean # True if agent is successfully warped, otherwise false.
function NavMeshAgent.Warp(newPosition) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Calls the method named methodName on every Lua Script in this game object or any of its children.
--- @param methodName string Name of the method to call.
--- @param parameter any? **Optional**(default = nil) Optional parameter to pass to the method (can be any value).
function NavMeshAgent.BroadcastMessage(methodName, parameter) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function NavMeshAgent.CompareTag(tag) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # Array of all Lua scripts that attached to the game object.
function NavMeshAgent.GetAllLuaScripts() end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the component of Type type if the game object has one attached, nil if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # the component of Type type
function NavMeshAgent.GetComponent(type) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function NavMeshAgent.GetComponentInChildren(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function NavMeshAgent.GetComponentInParent(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function NavMeshAgent.GetComponents(type) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function NavMeshAgent.GetComponentsInChildren(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function NavMeshAgent.GetComponentsInParent(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Calls the method named methodName on every Lua Script in this game object. 
--- @param methodName string Name of the method to call.
--- @param value any? **Optional**(default = nil) Optional parameter for the method.
function NavMeshAgent.SendMessage(methodName, value) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Calls the method named methodName on every LuaScript in this game object and on every ancestor of the behaviour.
--- @param methodName string Name of method to call.
--- @param value any? **Optional**(default = nil) Optional parameter value for the method.
function NavMeshAgent.SendMessageUpwards(methodName, value) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of the component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or nil.
function NavMeshAgent.TryGetComponent(type) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function NavMeshAgent.GetInstanceID() end

--- ##### Type *NavMeshData* inherits *Object*
--- ***
--- Contains and represents NavMesh data.
--- @class NavMeshData
--- @field position Vector3 Gets or sets the world space position of the NavMesh data. The default value is zero - that is, the world space origin.
--- @field rotation Quaternion Gets or sets the orientation of the NavMesh data. 
--- @field sourceBounds Bounds Returns the bounding volume of the input geometry used to build this NavMesh (Read Only).
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
NavMeshData = {}

--- ##### Constructor for *NavMeshData*
--- ***
--- Constructs a new object for representing a NavMesh for the default agent type.
--- @return NavMeshData
function NavMeshData() end

--- ##### Constructor for *NavMeshData*
--- ***
--- Constructs a new object representing a NavMesh for the specified agent type.
--- @param agentTypeID number The agent type ID to create a NavMesh for.
--- @return NavMeshData
function NavMeshData(agentTypeID) end

--- ##### Method Inherited from *Object*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function NavMeshData.GetInstanceID() end

--- ##### Type *NavMeshDataInstance*
--- ***
--- The instance is returned when adding NavMesh data.
--- @class NavMeshDataInstance
--- @field owner Object Get or set the owning Object.
--- @field valid boolean True if the NavMesh data is added to the navigation system - otherwise false (Read Only).
NavMeshDataInstance = {}

--- ##### Method
--- ***
--- Removes this instance from the NavMesh system.
function NavMeshDataInstance.Remove() end

--- ##### Type *NavMeshHit*
--- ***
--- Result information for NavMesh queries.
--- @class NavMeshHit
--- @field distance number Distance to the point of hit.
--- @field hit boolean Flag set when hit.
--- @field mask number Mask specifying NavMesh area at point of hit.
--- @field normal Vector3 Normal at the point of hit.
--- @field position Vector3 Position of hit.
NavMeshHit = {}

--- ##### Type *NavMeshLinkData*
--- ***
--- Used for runtime manipulation of links connecting polygons of the NavMesh.
--- @class NavMeshLinkData
--- @field agentTypeID number Specifies which agent type this link is available for.
--- @field area number Area type of the link.
--- @field bidirectional boolean If true, the link can be traversed in both directions, otherwise only from start to end position.
--- @field costModifier number If positive, overrides the pathfinder cost to traverse the link. 
--- @field endPosition Vector3 End position of the link.
--- @field startPosition Vector3 Start position of the link.
--- @field width number If positive, the link will be rectangle aligned along the line from start to end.
NavMeshLinkData = {}

--- ##### Constructor for *NavMeshLinkData*
--- ***
--- Create new NavMeshLinkData
--- @return NavMeshLinkData
function NavMeshLinkData() end

--- ##### Type *NavMeshLinkInstance*
--- ***
--- An instance representing a link available for pathfinding. It can also be used for removing NavMesh links from the navigation system.
--- @class NavMeshLinkInstance
--- @field owner Object Get or set the owning Object.  If the instance is invalid: setting the owner has no effect and getting it will return nil.
--- @field valid boolean True if the NavMesh link is added to the navigation system - otherwise false (Read Only).
NavMeshLinkInstance = {}

--- ##### Method
--- ***
--- Removes this instance from the game.
function NavMeshLinkInstance.Remove() end

--- ##### Type *NavMeshPath*
--- ***
--- A path as calculated by the navigation system. [Unity NavMeshPath(https://docs.unity3d.com/2019.4/Documentation/ScriptReference/AI.NavMeshPath.html)
--- @class NavMeshPath
--- @field corners Vector3[] Corner points of the path. (Read Only)
--- @field status NavMeshPathStatus Status of the path. (Read Only)
NavMeshPath = {}

--- ##### Constructor for *NavMeshPath*
--- ***
--- NavMeshPath constructor.
--- @return NavMeshPath
function NavMeshPath() end

--- ##### Method
--- ***
--- Erase all corner points from path.
function NavMeshPath.ClearCorners() end

--- ##### Method
--- ***
--- Calculate the corners for the path.
--- @return number # The number of corners along the path - including start and end points.
--- @return Vector3[] # Array of path corners.
function NavMeshPath.GetCornersNonAlloc() end

--- ##### Type *NavMeshQueryFilter*
--- ***
--- Specifies which agent type and areas to consider when searching the NavMesh. This struct is used with the NavMesh query methods overloaded with the query filter argument.
--- @class NavMeshQueryFilter
--- @field agentTypeID number The agent type ID, specifying which navigation meshes to consider for the query functions.
--- @field areaMask number A bitmask representing the traversable area types.
NavMeshQueryFilter = {}

--- ##### Method
--- ***
--- Returns the area cost multiplier for the given area type for this filter. The default value is 1.
--- @param areaIndex number Index to retreive the cost for.
--- @return number # The cost multiplier for the supplied area index.
function NavMeshQueryFilter.GetAreaCost(areaIndex) end

--- ##### Method
--- ***
--- Sets the pathfinding cost multiplier for this filter for a given area type.
--- @param areaIndex number The area index to set the cost for.
--- @param cost number The cost for the supplied area index.
function NavMeshQueryFilter.SetAreaCost(areaIndex, cost) end

--- ##### Type *NavMeshTriangulation*
--- ***
--- Contains data describing a triangulation of a navmesh.
--- @class NavMeshTriangulation
--- @field areas number[] NavMesh area indices for the navmesh triangulation. Contains one element for each triangle. 
--- @field indices number[] Triangle indices for the navmesh triangulation.  Contains 3 integers for each triangle. These integers refer to the vertices array.
--- @field vertices Vector3[] Vertices for the navmesh triangulation. Vertices are referenced by the indices.
NavMeshTriangulation = {}

--- ##### Type *Object*
--- ***
--- Base class for all objects Unity can reference. [Unity Object](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/Object.html)
--- @class Object
--- @field hideFlags HideFlags Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string The name of the object.
Object = {}

--- ##### Method
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function Object.GetInstanceID() end

--- ##### Static Method
--- ***
--- Removes a GameObject, component or asset.
--- @param obj Object The object to destroy.
--- @param t number? **Optional**(default = 0) The optional amount of time to delay before destroying the object.
function Object:Destroy(obj, t) end

--- ##### Static Method
--- ***
--- Returns the first active loaded object of Type type.
--- @param type userdata The type of object to find.
--- @return Object # first active loaded object of Type.
function Object:FindObjectOfType(type) end

--- ##### Static Method
--- ***
--- Returns a list of all active loaded objects of Type type.
--- @param type userdata The type of object to find.
--- @return Object[] # The array of objects found matching the type specified.
function Object:FindObjectsOfType(type) end

--- ##### Static Method
--- ***
--- Clones the object original and returns the clone.
--- @param original Object An existing object that you want to make a copy of.
--- @return Object # The instantiated clone.
function Object:Instantiate(original) end

--- ##### Static Method
--- ***
--- Clones the object original and returns the clone.
--- @param original Object An existing object that you want to make a copy of.
--- @param parent Transform Parent that will be assigned to the new object.
--- @return Object # The instantiated clone.
function Object:Instantiate(original, parent) end

--- ##### Static Method
--- ***
--- Clones the object original and returns the clone.
--- @param original Object An existing object that you want to make a copy of.
--- @param parent Transform Parent that will be assigned to the new object.
--- @param instantiateInWorldSpace boolean When you assign a parent Object, pass true to position the new object directly in world space. Pass false to set the Object’s position relative to its new parent..
--- @return Object # The instantiated clone.
function Object:Instantiate(original, parent, instantiateInWorldSpace) end

--- ##### Static Method
--- ***
--- Clones the object original and returns the clone.
--- @param original Object An existing object that you want to make a copy of.
--- @param position Vector3 Position for the new object.
--- @param rotation Quaternion Orientation of the new object.
--- @return Object #  The instantiated clone.
function Object:Instantiate(original, position, rotation) end

--- ##### Static Method
--- ***
--- Clones the object original and returns the clone.
--- @param original Object An existing object that you want to make a copy of.
--- @param position Vector3 Position for the new object.
--- @param rotation Quaternion Orientation of the new object.
--- @param parent Transform Parent that will be assigned to the new object.
--- @return Object #  The instantiated clone.
function Object:Instantiate(original, position, rotation, parent) end

--- ##### Type *OffMeshLink* inherits *Behaviour*
--- ***
--- Link allowing movement outside the planar navigation mesh.
--- @class OffMeshLink
--- @field activated boolean Is link active.
--- @field area number NavMesh area index for this OffMeshLink component.
--- @field autoUpdatePositions boolean Automatically update endpoints.
--- @field biDirectional boolean Can link be traversed in both directions.
--- @field costOverride number Modify pathfinding cost for the link.
--- @field endTransform Transform The transform representing link end position.
--- @field occupied boolean Is link occupied. (Read Only)
--- @field startTransform Transform The transform representing link start position.
--- @field enabled boolean **Inherited**  |  Enabled Behaviours are Updated, disabled Behaviours are not.
--- @field isActiveAndEnabled boolean **Inherited**  |  Has the Behaviour had active and enabled called?
--- @field gameObject GameObject **Read-Only**  **Inherited**  |  The game object this component is attached to. A component is always attached to a game object.
--- @field tag string **Read-Only**  **Inherited**  |  The tag of this game object.
--- @field transform Transform **Read-Only**  **Inherited**  |  The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
OffMeshLink = {}

--- ##### Method
--- ***
--- Explicitly update the link endpoints.
function OffMeshLink.UpdatePositions() end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Calls the method named methodName on every Lua Script in this game object or any of its children.
--- @param methodName string Name of the method to call.
--- @param parameter any? **Optional**(default = nil) Optional parameter to pass to the method (can be any value).
function OffMeshLink.BroadcastMessage(methodName, parameter) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function OffMeshLink.CompareTag(tag) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # Array of all Lua scripts that attached to the game object.
function OffMeshLink.GetAllLuaScripts() end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the component of Type type if the game object has one attached, nil if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # the component of Type type
function OffMeshLink.GetComponent(type) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function OffMeshLink.GetComponentInChildren(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function OffMeshLink.GetComponentInParent(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function OffMeshLink.GetComponents(type) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function OffMeshLink.GetComponentsInChildren(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function OffMeshLink.GetComponentsInParent(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Calls the method named methodName on every Lua Script in this game object. 
--- @param methodName string Name of the method to call.
--- @param value any? **Optional**(default = nil) Optional parameter for the method.
function OffMeshLink.SendMessage(methodName, value) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Calls the method named methodName on every LuaScript in this game object and on every ancestor of the behaviour.
--- @param methodName string Name of method to call.
--- @param value any? **Optional**(default = nil) Optional parameter value for the method.
function OffMeshLink.SendMessageUpwards(methodName, value) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of the component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or nil.
function OffMeshLink.TryGetComponent(type) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function OffMeshLink.GetInstanceID() end

--- ##### Type *OffMeshLinkData*
--- ***
--- State of OffMeshLink.
--- @class OffMeshLinkData
--- @field activated boolean Is link active (Read Only).
--- @field endPos Vector3 Link end world position (Read Only).
--- @field linkType OffMeshLinkType Link type specifier (Read Only).
--- @field offMeshLink OffMeshLink The OffMeshLink if the link type is a manually placed Offmeshlink (Read Only).
--- @field startPos Vector3 Link start world position (Read Only).
--- @field valid boolean Is link valid (Read Only).
OffMeshLinkData = {}

--- ##### Type *OSC*
--- ***
--- OSC (open sound control) Lua Interface which allows to bind Lua functions to be executed when OSC messages received. 
--- @class OSC
--- @field IsClientRunning boolean **Static**  **Read-Only**  |  Is OSC client running?
--- @field IsServerRunning boolean **Static**  **Read-Only**  |  Is the OSC server running? 
OSC = {}

--- ##### Static Method
--- ***
--- Returns true if the address is registered.
--- @param address string The address.
--- @return boolean # true if the address is registered.
function OSC:HasAddress(address) end

--- ##### Static Method
--- ***
--- Sends an OSC message to the specified address with basic parameters. Maximum of four (4) parameters allowed. Allowed parameter types are boolean, string and number (double). To have more control over parameter types, use type tag string. 
--- @param address string The destination OSC address.
--- @param parameters ... Optional parameters up to maximum 4. 
function OSC:SendMessage(address, ...) end

--- ##### Static Method
--- ***
--- Send OSC message to the specified address with type tag defined parameters. Maximum of four (4) parameters allowed. Use the Type Tag string to define the types of the variables. Follow the OSC specification on type characters [here]( https://opensoundcontrol.stanford.edu/spec-1_0.html#osc-type-tag-string) 
--- @param address string The destination OSC address.
--- @param TypeTag string The TypeTag string defining exact type of the parameters. 
--- @param _params ... Optional parameters to send. Max 4 allowed. Order and type must match the type tag. 
function OSC:SendMessageTypeTag(address, TypeTag, ...) end

--- ##### Static Method
--- ***
--- Binds an address to a provided Lua function. Returns true if the operation was successful. Note that the provided functions parameters must match message received by OSC both in order and type.
--- @param address string Address to bind.
--- @param _function function Function to be executed when OSC message received.
--- @return boolean # true if the operation was successful
function OSC:TryBindAddressPattern(address, _function) end

--- ##### Static Method
--- ***
--- Unbind a previously bound address. Returns true if the operation was successful. 
--- @param address string The address to unbind. 
--- @return boolean # true if the operation was successful
function OSC:TryUnBindAddressPattern(address) end

--- ##### Type *OSCMIDIMessage*
--- ***
--- OSC wrapper for MIDI message. The OSC MIDI wrapper contains one extra byte denoting the port ID of midi. 
--- @class OSCMIDIMessage
--- @field MIDIMessage MIDIMessage **Read-Only**  |  The embedded midi message. 
--- @field PortID number The MIDI port ID. [0-255]
OSCMIDIMessage = {}

--- ##### Constructor for *OSCMIDIMessage*
--- ***
--- Creates a new OSC Midi message. 
--- @param portID number Midi Port ID [0-255]
--- @return OSCMIDIMessage
function OSCMIDIMessage(portID) end

--- ##### Constructor for *OSCMIDIMessage*
--- ***
--- Creates a new OSC Midi message. 
--- @param portID number Midi port ID. [0-255]
--- @param message MIDIMessage MIDI Message
--- @return OSCMIDIMessage
function OSCMIDIMessage(portID, message) end

--- ##### Constructor for *OSCMIDIMessage*
--- ***
--- Creates a new OSC Midi message. 
--- @param portID number MIDI port ID [0-255]
--- @param MIDIFunction MIDIFunction MIDI message Function. 
--- @param channel number MIDI message channel. [0-15]
--- @param data1 number MIDI message first data byte [0-127]
--- @param data2 number MIDI message second data byte. [0-127]
--- @return OSCMIDIMessage
function OSCMIDIMessage(portID, MIDIFunction, channel, data1, data2) end

--- ##### Type *PhysicBox*
--- ***
--- Describes a box in space for physical calculations. Used for BoxCast.
--- @class PhysicBox
--- @field center Vector3 Center of the box.
--- @field direction Vector3 The direction in which to cast the box.
--- @field halfExtents Vector3 Half the size of the box in each dimension.
--- @field layerMask number A Layer mask that is used to selectively ignore colliders when casting a capsule. Physics.DefaultRaycastLayers by default.
--- @field maxDistance number The max length of the cast. Mathf.Infinity by default.
--- @field orientation Quaternion Rotation of the box. Quaternion.identity by default.
--- @field queryTriggerInteraction QueryTriggerInteraction Specifies whether this query should hit Triggers. `QueryTriggerInteraction.UseGlobal` by default.
PhysicBox = {}

--- ##### Constructor for *PhysicBox*
--- ***
--- Constructs new PhysicBox.
--- @param center Vector3 Center of the box.
--- @param halfExtents Vector3 Half the size of the box in each dimension.
--- @param direction Vector3 The direction in which to cast the box.
--- @return PhysicBox
function PhysicBox(center, halfExtents, direction) end

--- ##### Type *PhysicCapsule*
--- ***
--- Describes a capsule in space for physical calculations. Used for CapsuleCast.  
--- @class PhysicCapsule
--- @field direction Vector3 The direction into which to sweep the capsule.
--- @field layerMask number A Layer mask that is used to selectively ignore colliders when casting a capsule. `Physics.DefaultRaycastLayers` by default.
--- @field maxDistance number The max length of the sweep. `Mathf.Infinity` by default.
--- @field point1 Vector3 The center of the sphere at the start of the capsule.
--- @field point2 Vector3 The center of the sphere at the end of the capsule.
--- @field queryTriggerInteraction QueryTriggerInteraction Specifies whether this query should hit Triggers. `QueryTriggerInteraction.UseGlobal` by default.
--- @field radius number The radius of the capsule.
PhysicCapsule = {}

--- ##### Constructor for *PhysicCapsule*
--- ***
--- Constructs new PhysicCapsule. 
--- @param point1 Vector3 The center of the sphere at the start of the capsule.
--- @param point2 Vector3 The center of the sphere at the end of the capsule.
--- @param radius number The radius of the capsule.
--- @param direction Vector3 The direction into which to sweep the capsule.
--- @return PhysicCapsule
function PhysicCapsule(point1, point2, radius, direction) end

--- ##### Type *PhysicLine*
--- ***
--- Describes a line in space for physical calculations. Used for LineCast and more.
--- @class PhysicLine
--- @field end Vector3 Line End point.
--- @field layerMask number A Layer mask that is used to selectively ignore colliders when casting a ray. Default `Physic.DefaultRaycastLayers`.
--- @field queryTriggerInteraction QueryTriggerInteraction Specifies whether this query should hit Triggers. Default `QueryTriggerInteraction.UseGlobal`.
--- @field start Vector3 Line Start point.
PhysicLine = {}

--- ##### Constructor for *PhysicLine*
--- ***
--- Creates new PhysicLine
--- @param start Vector3 Start point.
--- @param _end Vector3 End point.
--- @return PhysicLine
function PhysicLine(start, _end) end

--- ##### Type *PhysicMaterial* inherits *Object*
--- ***
--- Physics material describes how to handle colliding objects (friction, bounciness). [Unity PhysicMaterial](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/PhysicMaterial.html)
--- @class PhysicMaterial
--- @field bounceCombine PhysicMaterialCombine Determines how the bounciness is combined.
--- @field bounciness number How bouncy is the surface? A value of 0 will not bounce. A value of 1 will bounce without any loss of energy.
--- @field dynamicFriction number The friction used when already moving. This value is usually between 0 and 1.
--- @field frictionCombine PhysicMaterialCombine Determines how the friction is combined.
--- @field staticFriction number The friction coefficient used when an object is lying on a surface.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
PhysicMaterial = {}

--- ##### Constructor for *PhysicMaterial*
--- ***
--- Creates a new material.
--- @return PhysicMaterial
function PhysicMaterial() end

--- ##### Method Inherited from *Object*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function PhysicMaterial.GetInstanceID() end

--- ##### Type *PhysicRay*
--- ***
--- Describes a Ray in space for physical calculations. Used for RayCast and more.
--- @class PhysicRay
--- @field layerMask number A Layer mask that is used to selectively ignore colliders when casting a ray. Default `Physics.DefaultRaycastLayers`.
--- @field maxDistance number The max distance the ray should check for collisions. Default `Mathf.Infinity`.
--- @field queryTriggerInteraction QueryTriggerInteraction Specifies whether this query should hit Triggers. Default `QueryTriggerInteraction.UseGlobal`.
--- @field ray Ray The starting point and direction of the ray.
PhysicRay = {}

--- ##### Constructor for *PhysicRay*
--- ***
--- Create new PhysicRay by origin and direction
--- @param origin Vector3 The starting point of the ray in world coordinates.
--- @param direction Vector3 The direction of the ray.
--- @return PhysicRay
function PhysicRay(origin, direction) end

--- ##### Constructor for *PhysicRay*
--- ***
--- Create new PhysicRay with providing a Ray.
--- @param ray Ray The starting point and direction of the ray.
--- @return PhysicRay
function PhysicRay(ray) end

--- ##### Type *Physics*
--- ***
--- Global physics properties and helper methods. [Unity Physics](https://docs.unity3d.com/2019.4/Documentation/ScriptReference/Physics.html)
--- @class Physics
--- @field AllLayers number **Static**  |  Layer mask constant to select all layers. (Read-only)
--- @field autoSimulation boolean **Static**  |  Sets whether the physics should be simulated automatically or not.
--- @field autoSyncTransforms boolean Whether or not to automatically sync transform changes with the physics system whenever a Transform component changes.
--- @field bounceThreshold number **Static**  |  Two colliding objects with a relative velocity below this will not bounce (default 2). Must be positive.
--- @field clothGravity Vector3 **Static**  |  Cloth Gravity setting. Set gravity for all cloth components.
--- @field defaultContactOffset number **Static**  |  The default contact offset of the newly created colliders.
--- @field defaultMaxAngularSpeed number **Static**  |  Default maximum angular speed of the dynamic Rigidbody, in radians (default 50).
--- @field DefaultRaycastLayers number **Static**  |  Layer mask constant to select default raycast layers. (constant)
--- @field defaultSolverIterations number The defaultSolverIterations determines how accurately Rigidbody joints and collision contacts are resolved. (default 6). Must be positive.
--- @field defaultSolverVelocityIterations number **Static**  |  The defaultSolverVelocityIterations affects how accurately the Rigidbody joints and collision contacts are resolved. (default 1). Must be positive.
--- @field gravity Vector3 **Static**  |  The gravity applied to all rigid bodies in the Scene.
--- @field IgnoreRaycastLayer number **Static**  |  Layer mask constant to select ignore raycast layer. (constant)
--- @field interCollisionDistance number **Static**  |  Sets the minimum separation distance for cloth inter-collision.  Cloth particles closer than this distance that belong to different Cloth objects will be separated.
--- @field interCollisionStiffness number **Static**  |  Sets the cloth inter-collision stiffness.
--- @field queriesHitBackfaces boolean **Static**  |  Whether physics queries should hit back-face triangles.
--- @field queriesHitTriggers boolean **Static**  |  Specifies whether queries (raycasts, spherecasts, overlap tests, etc.) hit Triggers by default.  This can be overridden on a per-query level by specifying the QueryTriggerInteraction parameter.
--- @field reuseCollisionCallbacks boolean **Static**  |  Determines whether the garbage collector should reuse only a single instance of a Collision type for all collision callbacks.
--- @field sleepThreshold number **Static**  |  The mass-normalized energy threshold, below which objects start going to sleep.
Physics = {}

--- ##### Static Method
--- ***
--- Prepares the Mesh for use with a MeshCollider.
--- @param meshID number The instance ID of the Mesh to bake collision data from.
--- @param convex boolean A flag to indicate whether to bake convex geometry or not.
function Physics:BakeMesh(meshID, convex) end

--- ##### Static Method
--- ***
--- Casts the box along a ray and returns detailed information on what was hit.
--- @param physicBox PhysicBox Physic Box to cast.
--- @return boolean # True, if any intersections were found.
--- @return RaycastHit # If true is returned, hitInfo will contain more information about where the collider was hit.
function Physics:BoxCast(physicBox) end

--- ##### Static Method
--- ***
--- Like Physics.BoxCast, but returns all hits.
--- @param physicBox PhysicBox The Physic Box to cast.
--- @return RaycastHit[] # All colliders that were hit.
function Physics:BoxCastAll(physicBox) end

--- ##### Static Method
--- ***
--- Casts a capsule against all colliders in the Scene and returns detailed information on what was hit.
--- @param physicCapsule PhysicCapsule The physic capsule to cast.
--- @return boolean # True when the capsule sweep intersects any collider, otherwise false.
--- @return RaycastHit # If true is returned, hitInfo will contain more information about where the collider was hit.
function Physics:CapsuleCast(physicCapsule) end

--- ##### Static Method
--- ***
--- Like Physics.CapsuleCast, but this function will return all hits the capsule sweep intersects.
--- @param physicCapsule PhysicCapsule The physic capsule to cast. 
--- @return RaycastHit[] # An array of all colliders hit in the sweep.
function Physics:CapsuleCastAll(physicCapsule) end

--- ##### Static Method
--- ***
--- Check whether the given box overlaps with other colliders or not.
--- @param physicBox PhysicBox The physic box. The `direction` field of the PhysicBox will be ignored, so can be a nil. 
--- @return boolean # True, if the box overlaps with any colliders.
function Physics:CheckBox(physicBox) end

--- ##### Static Method
--- ***
--- Checks if any colliders overlap a capsule-shaped volume in world space.
--- @param physicCapsule PhysicCapsule The physic capsule. The `direction` field of the PhysicCapsule will be ignored, so can be a nil. 
--- @return boolean # true if any colliders overlap a capsule-shaped volume in world space.
function Physics:CheckCapsule(physicCapsule) end

--- ##### Static Method
--- ***
--- Returns true if there are any colliders overlapping the sphere defined by PhysicSphere.
--- @param physicSphere PhysicSphere The physic sphere. The `direction` field of the PhysicSphere will be ignored, so can be a nil. 
--- @return boolean # true if there are any colliders overlapping the sphere
function Physics:CheckSphere(physicSphere) end

--- ##### Static Method
--- ***
--- Returns a point on the given collider that is closest to the specified location.
--- @param point Vector3 Location you want to find the closest point to.
--- @param collider Vector3 The collider that you find the closest point on.
--- @param position Vector3 The position of the collider.
--- @param rotation Vector3 The rotation of the collider.
--- @return Vector3 # The point on the collider that is closest to the specified location.
function Physics:ClosestPoint(point, collider, position, rotation) end

--- ##### Static Method
--- ***
--- Compute the minimal translation required to separate the given colliders apart at specified poses.
--- @param colliderA Collider The first collider.
--- @param positionA Vector3 Position of the first collider.
--- @param rotationA Quaternion Rotation of the first collider.
--- @param colliderB Collider The second collider.
--- @param positionB Vector3 Position of the second collider.
--- @param rotationB Quaternion Rotation of the second collider.
--- @return boolean # True, if the colliders overlap at the given poses.
--- @return Vector3 # Direction along which the translation required to separate the colliders apart is minimal.
--- @return number # The distance along direction that is required to separate the colliders apart.
function Physics:ComputePenetration(colliderA, positionA, rotationA, colliderB, positionB, rotationB) end

--- ##### Static Method
--- ***
--- Checks whether the collision detection system will ignore all collisions/triggers between collider1 and collider2 or not.
--- @param collider1 Collider The first collider to compare to collider2.
--- @param collider2 Collider The second collider to compare to collider1.
--- @return boolean # Whether the collision detection system will ignore all collisions/triggers between collider1 and collider2 or not.
function Physics:GetIgnoreCollision(collider1, collider2) end

--- ##### Static Method
--- ***
--- Are collisions between layer1 and layer2 being ignored?
--- @param layer1 number layer1
--- @param layer2 number layer2
--- @return boolean # the value set by `Physics.IgnoreLayerCollision` or in the Physics inspector.
function Physics:GetIgnoreLayerCollision(layer1, layer2) end

--- ##### Static Method
--- ***
--- Makes the collision detection system ignore all collisions between collider1 and collider2.
--- @param collider1 Collider Any collider.
--- @param collider2 Collider Another collider you want to have collider1 to start or stop ignoring collisions with.
--- @param ignore boolean? **Optional**(default = true) Whether or not the collisions between the two colliders should be ignored or not.
function Physics:IgnoreCollision(collider1, collider2, ignore) end

--- ##### Static Method
--- ***
--- Returns true if there is any collider intersecting the line between start and end.
--- @param physicLine PhysicLine The physic line to cast.
--- @return boolean # true if there is any collider intersecting the line.
--- @return RaycastHit # hitInfo contain more information about where the collider was hit.
function Physics:Linecast(physicLine) end

--- ##### Static Method
--- ***
--- Find all colliders touching or inside of the given physic box.
--- @param physicBox PhysicBox The physic box. The `direction` field of the PhysicBox will be ignored, so can be a nil.
--- @return Collider[] # Colliders that overlap with the given box.
function Physics:OverlapBox(physicBox) end

--- ##### Static Method
--- ***
--- Check the given capsule against the physics world and return all overlapping colliders.
--- @param physicCapsule PhysicCapsule The physic capsule. The `direction` field of the PhysicCapsule will be ignored, so can be a nil. 
--- @return Collider[] # Colliders touching or inside the capsule.
function Physics:OverlapCapsule(physicCapsule) end

--- ##### Static Method
--- ***
--- Computes and stores colliders touching or inside the sphere.
--- @param physicSphere PhysicSphere The physic sphere. The `direction` field of the PhysicSphere will be ignored, so can be a nil. 
--- @return Collider[] # An array with all colliders touching or inside the sphere.
function Physics:OverlapSphere(physicSphere) end

--- ##### Static Method
--- ***
--- Casts a ray, from point origin, in direction direction, of length maxDistance, against all colliders in the Scene.
--- @param physicRay PhysicRay The physic ray to cast.
--- @return boolean # true if the ray intersects with a Collider, otherwise false.
--- @return RaycastHit # hitInfo contain more information about where the closest collider was hit. 
function Physics:Raycast(physicRay) end

--- ##### Static Method
--- ***
--- Casts a ray through the Scene and returns all hits. Note that order of the results is undefined.
--- @param physicRay PhysicRay The physic ray to cast.
--- @return RaycastHit[] # An array of RaycastHit objects. Note that the order of the results is undefined.
function Physics:RaycastAll(physicRay) end

--- ##### Static Method
--- ***
--- Rebuild the broadphase interest regions as well as set the world boundaries.
--- @param worldBounds Bounds Boundaries of the physics world.
--- @param subdivisions number How many cells to create along x and z axis.
function Physics:RebuildBroadphaseRegions(worldBounds, subdivisions) end

--- ##### Static Method
--- ***
--- Simulate physics in the Scene.
--- @param step number The time to advance physics by.
function Physics:Simulate(step) end

--- ##### Static Method
--- ***
--- Casts a sphere along a ray and returns detailed information on what was hit.
--- @param physicSphere PhysicSphere The PhysicSphere to cast. 
--- @return boolean # True when the sphere sweep intersects any collider, otherwise false.
--- @return RaycastHit # hitInfo contain more information about where the collider was hit.
function Physics:SphereCast(physicSphere) end

--- ##### Static Method
--- ***
--- Like Physics.SphereCast, but this function will return all hits the sphere sweep intersects.
--- @param physicSphere PhysicSphere The PhysicSphere to cast
--- @return RaycastHit[] # An array of all colliders hit in the sweep.
function Physics:SphereCastAll(physicSphere) end

--- ##### Static Method
--- ***
--- Apply Transform changes to the physics engine.
function Physics:SyncTransforms() end

--- ##### Type *PhysicSphere*
--- ***
--- Describes a Sphere in space for physical calculations. Used for SphereCast and more.
--- @class PhysicSphere
--- @field direction Vector3 The direction into which to sweep the sphere.
--- @field layerMask number A Layer mask that is used to selectively ignore colliders when casting a capsule. Default `Physics.DefaultRaycastLayers`.
--- @field maxDistance number The max length of the cast. Default `Mathf.Infinity`.
--- @field origin Vector3 The center of the sphere at the start of the sweep.
--- @field queryTriggerInteraction QueryTriggerInteraction Specifies whether this query should hit Triggers. Default `QueryTriggerInteraction.UseGlobal`.
--- @field radius number The radius of the sphere.
PhysicSphere = {}

--- ##### Constructor for *PhysicSphere*
--- ***
--- Constructs new PhysicSphere. 
--- @param origin Vector3 The center of the sphere
--- @param radius number The radius of the sphere.
--- @param direction Vector3 The direction into which to sweep the sphere.
--- @return PhysicSphere
function PhysicSphere(origin, radius, direction) end

--- ##### Type *Plane*
--- ***
--- Representation of a plane in 3D space.<br> See [Unity Plane](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/Plane.html) for more info.
--- @class Plane
--- @field distance number Distance from the origin to the plane.
--- @field flipped Plane Returns a copy of the plane that faces in the opposite direction. (Read only)
--- @field normal Vector3 Normal vector of the plane.
Plane = {}

--- ##### Constructor for *Plane*
--- ***
--- Creates a plane.
--- @param inNormal Vector3 plane normal. must be a normalized vector.
--- @param inPoint Vector3 the point which plane goes through.
--- @return Plane
function Plane(inNormal, inPoint) end

--- ##### Constructor for *Plane*
--- ***
--- Creates a plane.
--- @param inNormal Vector3 plane's normal
--- @param d number distance
--- @return Plane
function Plane(inNormal, d) end

--- ##### Constructor for *Plane*
--- ***
--- Creates a plane.
--- @param a Vector3 point A
--- @param b Vector3 Point B
--- @param c Vector3 Point C
--- @return Plane
function Plane(a, b, c) end

--- ##### Method
--- ***
--- For a given `point` returns the closest point on the plane.
--- @param point Vector3 The point to project onto the plane.
--- @return Vector3 # A point on the plane that is closest to point.
function Plane.ClosestPointOnPlane(point) end

--- ##### Method
--- ***
--- Makes the plane face in the opposite direction.
function Plane.Flip() end

--- ##### Method
--- ***
--- Returns a signed distance from plane to point.
--- @param point Vector3 point
--- @return number # distance from plane to point.
function Plane.GetDistanceToPoint(point) end

--- ##### Method
--- ***
--- Is a point on the positive side of the plane?
--- @param point Vector3 point
--- @return boolean # True if point on the positive side of the plane
function Plane.GetSide(point) end

--- ##### Method
--- ***
--- Intersects a ray with the plane.
--- @param ray Ray the Ray to be cast
--- @return boolean # Is intersect?
--- @return number # Distance from Intersect
function Plane.Raycast(ray) end

--- ##### Method
--- ***
--- Are two points on the same side of the plane?
--- @param point0 Vector3 Point 0
--- @param point1 Vector3 Point 1
--- @return boolean # True if two points on the same side of the plane
function Plane.SameSide(point0, point1) end

--- ##### Method
--- ***
--- Sets a plane using three points that lie within it. The points go around clockwise as you look down on the top surface of the plane.
--- @param a Vector3 First point in clockwise order.
--- @param b Vector3 Second point in clockwise order.
--- @param c Vector3 Third point in clockwise order.
function Plane.Set3Points(a, b, c) end

--- ##### Method
--- ***
--- Sets a plane using a point that lies within it along with a normal to orient it.<br>Note that the normal must be a normalised vector.
--- @param inNormal Vector3 The plane's normal vector.
--- @param inPoint Vector3 A point that lies on the plane.
function Plane.SetNormalAndPosition(inNormal, inPoint) end

--- ##### Method
--- ***
--- Moves the plane in space by the `translation` vector.
--- @param translation Vector3 The offset in space to move the plane with.
function Plane.Translate(translation) end

--- ##### Static Method
--- ***
--- Returns a copy of the given plane that is moved in space by the given `translation`.
--- @param plane Plane The plane to move in space.
--- @param translation Vector3 The offset in space to move the plane with.
--- @return Plane # The translated plane.
function Plane:Translate(plane, translation) end

--- ##### Type *PlayableAsset* inherits *table*
--- ***
--- A base class for assets that can be used to instantiate a Playable at runtime.<br> A minimal interface for [Unity PlayableAsset](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/Playables.PlayableAsset.html)
--- @class PlayableAsset
--- @field duration number The playback duration in seconds of the instantiated Playable.
PlayableAsset = {}

--- ##### Type *PlayableDirector* inherits *Behaviour*
--- ***
--- Instantiates a PlayableAsset and controls playback of Playable objects.<br> Check Unity [PlayableDirector](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/Playables.PlayableDirector.html)
--- @class PlayableDirector
--- @field duration number The duration of the Playable in seconds.
--- @field extrapolationMode DirectorWrapMode Controls how the time is incremented when it goes beyond the duration of the playable.
--- @field initialTime number The time at which the Playable should start when first played.
--- @field paused PlayableDirectorpausedEventHandler **Event**  | Event that is raised when a PlayableDirector component has paused.
--- @field played PlayableDirectorplayedEventHandler **Event**  | Event that is raised when a PlayableDirector component has begun playing.
--- @field playOnAwake boolean Whether the playable asset will start playing back as soon as the component awakes.
--- @field state PlayState The current playing state of the component. (Read Only)
--- @field stopped PlayableDirectorstoppedEventHandler **Event**  | Event that is raised when a PlayableDirector component has stopped.
--- @field time number The component's current time. This value is incremented according to the PlayableDirector.timeUpdateMode when it is playing. You can also change this value manually.
--- @field timeUpdateMode DirectorUpdateMode Controls how time is incremented when playing back.
--- @field enabled boolean **Inherited**  |  Enabled Behaviours are Updated, disabled Behaviours are not.
--- @field isActiveAndEnabled boolean **Inherited**  |  Has the Behaviour had active and enabled called?
--- @field gameObject GameObject **Read-Only**  **Inherited**  |  The game object this component is attached to. A component is always attached to a game object.
--- @field tag string **Read-Only**  **Inherited**  |  The tag of this game object.
--- @field transform Transform **Read-Only**  **Inherited**  |  The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
PlayableDirector = {}

--- ##### Method
--- ***
--- Clears the binding of a reference object.  Use this method to clear the binding and remove the dependency to the source object. For example, use this method to clear the binding for a Timeline track that is no longer used.
--- @param key Object The source object in the PlayableBinding.
function PlayableDirector.ClearGenericBinding(key) end

--- ##### Method
--- ***
--- Clears an exposed reference value.
--- @param id PropertyName Identifier of the ExposedReference.
function PlayableDirector.ClearReferenceValue(id) end

--- ##### Method
--- ***
--- Evaluates the currently playing Playable at the current time.
function PlayableDirector.Evaluate() end

--- ##### Method
--- ***
--- Returns a binding to a reference object.  In Timeline this is the track to bind an object to. This typically corresponds to the PlayableBinding.sourceObject in the PlayableAsset.
--- @param key Object The object that acts as a key.
--- @return Object # binding to a reference object.
function PlayableDirector.GetGenericBinding(key) end

--- ##### Method
--- ***
--- Retreives an ExposedReference binding.
--- @param id PropertyName Identifier of the ExposedReference.
--- @return Object # ExposedReference binding.
--- @return boolean # True the reference was found.
function PlayableDirector.GetReferenceValue(id) end

--- ##### Method
--- ***
--- Pauses playback of the currently running playable.
function PlayableDirector.Pause() end

--- ##### Method
--- ***
--- Instatiates a Playable using the provided PlayableAsset and starts playback.
--- @param asset PlayableAsset An asset to instantiate a playable from.
--- @param mode DirectorWrapMode What to do when the time passes the duration of the playable.
function PlayableDirector.Play(asset, mode) end

--- ##### Method
--- ***
--- Instatiates a Playable using the provided PlayableAsset and starts playback.
--- @param asset PlayableAsset An asset to instantiate a playable from.
function PlayableDirector.Play(asset) end

--- ##### Method
--- ***
--- Instatiates a Playable using the provided PlayableAsset and starts playback.
function PlayableDirector.Play() end

--- ##### Method
--- ***
--- Rebinds each PlayableOutput of the PlayableGraph.  This function updates the PlayableOutputs binding information. It should be used if a component has been added or deleted. New Animator, AudioSource and NotificationReceiver objects can be discovered this way without rebuilding the graph. 
function PlayableDirector.RebindPlayableGraphOutputs() end

--- ##### Method
--- ***
--- Discards the existing PlayableGraph and creates a new instance.  When the PlayableDirector starts playback, it creates a PlayableGraph from the assigned PlayableAsset. Use this method when the assigned PlayableAsset has changed and it is necessary to show the changes during playback.  RebuildGraph attempts to maintain the current playback state. For example, if the PlayableDirector has not started playback, RebuildGraph constructs a new PlayableGraph and does not start playback. If the PlayableDirector is playing an existing graph, RebuildGraph stops playback, destroys the graph, creates a new instance of the graph, and resumes playback.
function PlayableDirector.RebuildGraph() end

--- ##### Method
--- ***
--- Resume playing a paused playable.
function PlayableDirector.Resume() end

--- ##### Method
--- ***
--- Sets the binding of a reference object from a PlayableBinding.Use this method to associate assets to objects loaded in the scene. For example, use SetGenericBinding to bind a Timeline track to a GameObject or Component.If the value is set to null, the source object is bound to null and the dependency between the PlayableDirector and the source object is kept.
--- @param key Object The source object in the PlayableBinding.
--- @param value Object The object to bind to the key.
function PlayableDirector.SetGenericBinding(key, value) end

--- ##### Method
--- ***
--- Sets an ExposedReference value.
--- @param id PropertyName Identifier of the ExposedReference.
--- @param value Object The object to bind to set the reference value to.
function PlayableDirector.SetReferenceValue(id, value) end

--- ##### Method
--- ***
--- Stops playback of the current Playable and destroys the corresponding graph.
function PlayableDirector.Stop() end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Calls the method named methodName on every Lua Script in this game object or any of its children.
--- @param methodName string Name of the method to call.
--- @param parameter any? **Optional**(default = nil) Optional parameter to pass to the method (can be any value).
function PlayableDirector.BroadcastMessage(methodName, parameter) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function PlayableDirector.CompareTag(tag) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # Array of all Lua scripts that attached to the game object.
function PlayableDirector.GetAllLuaScripts() end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the component of Type type if the game object has one attached, nil if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # the component of Type type
function PlayableDirector.GetComponent(type) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function PlayableDirector.GetComponentInChildren(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function PlayableDirector.GetComponentInParent(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function PlayableDirector.GetComponents(type) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function PlayableDirector.GetComponentsInChildren(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function PlayableDirector.GetComponentsInParent(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Calls the method named methodName on every Lua Script in this game object. 
--- @param methodName string Name of the method to call.
--- @param value any? **Optional**(default = nil) Optional parameter for the method.
function PlayableDirector.SendMessage(methodName, value) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Calls the method named methodName on every LuaScript in this game object and on every ancestor of the behaviour.
--- @param methodName string Name of method to call.
--- @param value any? **Optional**(default = nil) Optional parameter value for the method.
function PlayableDirector.SendMessageUpwards(methodName, value) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of the component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or nil.
function PlayableDirector.TryGetComponent(type) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function PlayableDirector.GetInstanceID() end

--- ##### Type
--- ***
--- Event Handler
--- @class PlayableDirectorpausedEventHandler : EventHandler
PlayableDirectorpausedEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun()  Function to registered
function PlayableDirectorpausedEventHandler.Add(handler)end

--- ##### Type
--- ***
--- Event Handler
--- @class PlayableDirectorplayedEventHandler : EventHandler
PlayableDirectorplayedEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun()  Function to registered
function PlayableDirectorplayedEventHandler.Add(handler)end

--- ##### Type
--- ***
--- Event Handler
--- @class PlayableDirectorstoppedEventHandler : EventHandler
PlayableDirectorstoppedEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun()  Function to registered
function PlayableDirectorstoppedEventHandler.Add(handler)end

--- ##### Type *PlayerLocomotion*
--- ***
--- A Special kind of type which manages the locomotion values of a player. Can be used to set or get the various value regarding player control.
--- @class PlayerLocomotion
PlayerLocomotion = {}

--- ##### Method
--- ***
--- Gets the dashing multiplier.
--- @return number # the current dashing multiplier
function PlayerLocomotion.GetDashingMultiplier() end

--- ##### Method
--- ***
--- Gets the current jump speed.
--- @return number # current jump speed
function PlayerLocomotion.GetJumpSpeed() end

--- ##### Method
--- ***
--- Gets the current walking speed.
--- @return number # The current walking speed.
function PlayerLocomotion.GetWalkingSpeed() end

--- ##### Method
--- ***
--- Is the player allowed to climb on the walls? 
--- @return boolean # true 
function PlayerLocomotion.IsClimbEnabled() end

--- ##### Method
--- ***
--- Checks if the dashing is enabled. Returns true if the dashing is enabled.
--- @return boolean # true if the dashing is enabled.
function PlayerLocomotion.IsDashingEnabled() end

--- ##### Method
--- ***
--- Checks if the Holo Teleport mode is enabled. Returns true if the Holo Teleport mode is enabled.
--- @return boolean # true if the Holo Teleport mode is enabled.
function PlayerLocomotion.IsHoloTeleportModeEnabled() end

--- ##### Method
--- ***
--- Checks if the jumping is enabled. Returns true if the jumping is enabled.
--- @return boolean # true if the jumping is enabled.
function PlayerLocomotion.IsJumpEnabled() end

--- ##### Method
--- ***
--- Checks if the locomotion is enabled for the player. Returns true if the locomotion is enabled.
--- @return boolean # true if the locomotion is enabled.
function PlayerLocomotion.IsLocomotionEnabled() end

--- ##### Method
--- ***
--- Checks if the Teleport mode is enabled. Returns true if the Teleport mode is enabled.
--- @return boolean # value
function PlayerLocomotion.IsTeleportModeEnabled() end

--- ##### Method
--- ***
--- Checks if the turning is enabled. Returns true if the turning is enabled.
--- @return boolean # true if the turning is enabled.
function PlayerLocomotion.IsTurnEnabled() end

--- ##### Method
--- ***
--- Checks if the walking is enabled. Returns true if the walking is enabled.
--- @return boolean # true if the walking is enabled.
function PlayerLocomotion.IsWalkingEnabled() end

--- ##### Method
--- ***
--- Checks if the walk mode is enabled. Returns true if the walk mode is enabled.
--- @return boolean # true if the walk mode is enabled.
function PlayerLocomotion.IsWalkModeEnabled() end

--- ##### Method
--- ***
--- Reverts the user’s locomotion type to their preferred locomotion. 
function PlayerLocomotion.RevertLocomotionType() end

--- ##### Method
--- ***
--- Sets the dashing multiplier.
--- @param value number new dashing multiplier [0.0-2.0]  
function PlayerLocomotion.SetDashingMultiplier(value) end

--- ##### Method
--- ***
--- Sets the values of the locomotion to global default. The global default values are defined by ML developers.  
function PlayerLocomotion.SetDefault() end

--- ##### Method
--- ***
--- Sets the jump speed.
--- @param value number New jump speed [0.0,15.0]
function PlayerLocomotion.SetJumpSpeed(value) end

--- ##### Method
--- ***
--- Sets the walking speed of the player. 
--- @param value number new walking speed [0.0-10.0]
function PlayerLocomotion.SetWalkingSpeed(value) end

--- ##### Method
--- ***
--- Sets the values of the locomotion to the world default. The world default values are defined in World Descriptor.
function PlayerLocomotion.SetWorldDefault() end

--- ##### Method
--- ***
--- Toggle if the player can climb the walls or not.
--- @param value boolean Toggle value. True if the player can climb the walls, false otherwise. 
function PlayerLocomotion.ToggleClimb(value) end

--- ##### Method
--- ***
--- Enables or disables dashing for the player. This has no effect on walking.
--- @param value boolean True to enable, false to disable.
function PlayerLocomotion.ToggleDashing(value) end

--- ##### Method
--- ***
--- Enables or disables the Holo Teleport Mode. 
--- @param value boolean True to enable, false to disable.
function PlayerLocomotion.ToggleHoloTeleportMode(value) end

--- ##### Method
--- ***
--- Enables or disables jumping for the player.
--- @param value boolean True to enable, false to disable.
function PlayerLocomotion.ToggleJump(value) end

--- ##### Method
--- ***
--- Enables or disables all the locomotion for player. Disabling and enabling does not override previously set individual values.
--- @param value boolean True to enable, false to disable.
function PlayerLocomotion.ToggleLocomotion(value) end

--- ##### Method
--- ***
--- Enables or disables the Teleport Mode.
--- @param value boolean True to enable, false to disable.
function PlayerLocomotion.ToggleTeleportMode(value) end

--- ##### Method
--- ***
--- Enables or disables turning for the player.
--- @param value boolean True to enable, false to disable.
function PlayerLocomotion.ToggleTurn(value) end

--- ##### Method
--- ***
--- Enables or disables the walking of the player. The dashing is also disables when the walking is disabled.
--- @param value boolean True to enable, false to disable.
function PlayerLocomotion.ToggleWalking(value) end

--- ##### Method
--- ***
--- Enables or disables the walk mode. 
--- @param value boolean True to enable, false to disable.
function PlayerLocomotion.ToggleWalkMode(value) end

--- ##### Type *Promise*
--- ***
--- A Promise object represents the eventual completion (or failure) of an asynchronous operation and its resulting value. This allows execution of asynchronous operation in a synchronous fashion by associating handlers to eventual outcomes of the promise. A promise can result in success, rejection, or error. A promise which is not resulted in anything is in pending state. 
--- @class Promise
--- @field Error string **Read-Only**  |  The Error message (if there are any) of the promise if it is resulted in Error state.
--- @field Result any **Read-Only**  |  The result of the promise if it is fulfilled and a result expected. Nil otherwise.
--- @field State PromiseState **Read-Only**  |  State of the current promise.
Promise = {}

--- ##### Method
--- ***
--- Associates a handler to be called when promise encounters an error. The Error string will be passed to associated function. 
--- @param onError function The handler to be called when promise encounters an error.
--- @return Promise # itself.
function Promise.Catch(onError) end

--- ##### Method
--- ***
--- Associate handlers to called when promise if fulfilled or rejected. Note that the promise invokes the associated handlers in the main game thread; therefore, every API can be used safely within handlers. 
--- @param onFulfill function Handler to be called when the promise fulfilled. The result of the promised passed as parameter to this function.
--- @param onRejected function? **Optional**(default = nil) The handler to be called when the promise is rejected. 
--- @return Promise # itself. 
function Promise.Then(onFulfill, onRejected) end

--- ##### Type *PropertyName*
--- ***
--- Represents a string as an int for efficient lookup and comparison. Use this for common PropertyNames. Internally stores just an int to represent the string. A PropertyName can be created from a string but can not be converted back to a string. The same string always results in the same int representing that string. Thus this is a very efficient string representation in both memory and speed when all you need is comparison.<br> [Unity PropertyName](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/PropertyName.html)
--- @class PropertyName
PropertyName = {}

--- ##### Constructor for *PropertyName*
--- ***
--- Initializes the PropertyName using a string.
--- @param name string name
--- @return PropertyName
function PropertyName(name) end

--- ##### Static Method
--- ***
--- Indicates whether the specified PropertyName is an Empty string.
--- @param prop PropertyName specified PropertyName
--- @return boolean # True if the specified PropertyName is an Empty string.
function PropertyName:IsNullOrEmpty(prop) end

--- ##### Type *Quaternion*
--- ***
--- Quaternions are used to represent rotations. They are compact, don't suffer from gimbal lock and can easily be interpolated. Unity internally uses Quaternions to represent all rotations.
--- @class Quaternion
--- @field eulerAngles Vector3 Returns or sets the euler angle representation of the rotation.
--- @field identity Quaternion **Static**  |  The identity rotation (Read Only).
--- @field normalized Quaternion Returns this quaternion with a magnitude of 1 (Read Only).
--- @field w number W component of the Quaternion. Do not directly modify quaternions.
--- @field x number X component of the Quaternion. Don't modify this directly unless you know quaternions inside out.
--- @field y number Y component of the Quaternion. Don't modify this directly unless you know quaternions inside out.
--- @field z number 
--- @operator mul(Quaternion) : Quaternion # Combines rotations lhs and rhs.
--- @operator mul(Vector3) : Vector3 # Rotates the point `rhs` with rotation `lhs`.
Quaternion = {}

--- ##### Constructor for *Quaternion*
--- ***
--- Constructs new Quaternion with given x,y,z,w components.
--- @param x number x
--- @param y number y
--- @param z number z
--- @param w number w
--- @return Quaternion
function Quaternion(x, y, z, w) end

--- ##### Method
--- ***
--- Interpolates between a and b by t and normalizes the result afterwards. The parameter t is not clamped.
--- @param a Quaternion a
--- @param b Quaternion b
--- @param t number t
--- @return Quaternion # result
function Quaternion.LerpUnclamped(a, b, t) end

--- ##### Method
--- ***
--- Set x, y, z and w components of an existing Quaternion.
--- @param newX number new X
--- @param newY number new Y
--- @param newZ number new Z
--- @param newW number new W
function Quaternion.Set(newX, newY, newZ, newW) end

--- ##### Method
--- ***
--- Creates a rotation which rotates from fromDirection to toDirection.
--- @param fromDirection Vector3 from Direction
--- @param toDirection Vector3 to Direction
function Quaternion.SetFromToRotation(fromDirection, toDirection) end

--- ##### Method
--- ***
--- Creates a rotation with the specified forward and upwards directions.
--- @param view Vector3 The direction to look in.
--- @param up Vector3? **Optional**(default = Vector3.up) The vector that defines in which direction up is.
function Quaternion.SetLookRotation(view, up) end

--- ##### Method
--- ***
--- Converts a rotation to angle-axis representation (angles in degrees).
--- @return number # angle
--- @return Vector3 # axis
function Quaternion.ToAngleAxis() end

--- ##### Static Method
--- ***
--- Returns the angle in degrees between two rotations a and b.
--- @param a Quaternion a
--- @param b Quaternion b
--- @return number # angle in degrees
function Quaternion:Angle(a, b) end

--- ##### Static Method
--- ***
--- Creates a rotation which rotates angle degrees around axis.
--- @param angle number angle
--- @param axis Vector3 axis
--- @return Quaternion # rotation
function Quaternion:AngleAxis(angle, axis) end

--- ##### Static Method
--- ***
--- The dot product between two rotations.
--- @param a Quaternion a
--- @param b Quaternion b
--- @return number # dot product
function Quaternion:Dot(a, b) end

--- ##### Static Method
--- ***
--- Returns a rotation that rotates z degrees around the z axis, x degrees around the x axis, and y degrees around the y axis; applied in that order.
--- @param x number x
--- @param y number y
--- @param z number z
--- @return Quaternion # 
function Quaternion:Euler(x, y, z) end

--- ##### Static Method
--- ***
--- Creates a rotation which rotates from fromDirection to toDirection.
--- @param fromDirection Vector3 from Direction
--- @param toDirection Vector3 to Direction
--- @return Quaternion #  rotation which rotates from fromDirection to toDirection.
function Quaternion:FromToRotation(fromDirection, toDirection) end

--- ##### Static Method
--- ***
--- Returns the Inverse of rotation.
--- @param rotation Quaternion rotation
--- @return Quaternion # the Inverse of rotation.
function Quaternion:Inverse(rotation) end

--- ##### Static Method
--- ***
--- Interpolates between a and b by t and normalizes the result afterwards. The parameter t is clamped to the range [0, 1].
--- @param a Quaternion a
--- @param b Quaternion b
--- @param t number t
--- @return Quaternion # result
function Quaternion:Lerp(a, b, t) end

--- ##### Static Method
--- ***
--- Creates a rotation with the specified forward and upwards directions.
--- @param forward Vector3 The direction to look in.
--- @param upwards  Vector3? **Optional**(default = Vector3.up) The vector that defines in which direction up is.
--- @return Quaternion # a rotation with the specified forward and upwards directions.
function Quaternion:LookRotation(forward, upwards ) end

--- ##### Static Method
--- ***
--- Converts this quaternion to one with the same orientation but with a magnitude of 1.
--- @param q Quaternion q
--- @return Quaternion # normalized q
function Quaternion:Normalize(q) end

--- ##### Static Method
--- ***
--- Rotates a rotation from towards to.
--- @param from Quaternion from
--- @param to Quaternion to
--- @param  maxDegreesDelta number angular step
--- @return Quaternion # rotation
function Quaternion:RotateTowards(from, to,  maxDegreesDelta) end

--- ##### Static Method
--- ***
--- Spherically interpolates between a and b by t. The parameter t is clamped to the range [0, 1].
--- @param a Quaternion a
--- @param b Quaternion b
--- @param t number t
--- @return Quaternion # result
function Quaternion:Slerp(a, b, t) end

--- ##### Static Method
--- ***
--- Spherically interpolates between a and b by t. The parameter t is not clamped.
--- @param a Quaternion a
--- @param b Quaternion b
--- @param t number 
--- @return Quaternion # result
function Quaternion:SlerpUnclamped(a, b, t) end

--- ##### Type *Ray*
--- ***
--- A ray is an infinite line starting at origin and going in some direction. [Unity Ray](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/Ray.html)
--- @class Ray
--- @field direction Vector3 The direction of the ray.
--- @field origin Vector3 The origin point of the ray.
Ray = {}

--- ##### Constructor for *Ray*
--- ***
--- 
--- @param origin Vector3 origin
--- @param direction Vector3 direction
--- @return Ray
function Ray(origin, direction) end

--- ##### Method
--- ***
--- Returns a point at distance units along the ray.
--- @param distance number distance
--- @return Vector3 # a point at distance units along the ray.
function Ray.GetPoint(distance) end

--- ##### Type *RaycastHit*
--- ***
--- Structure used to get information back from a raycast. [Unity RaycastHit](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/RaycastHit.html)
--- @class RaycastHit
--- @field barycentricCoordinate Vector3 
--- @field collider Collider The Collider that was hit.
--- @field distance number The distance from the ray's origin to the impact point.
--- @field lightmapCoord Vector2 The uv lightmap coordinate at the impact point.
--- @field normal Vector3 The normal of the surface the ray hit.
--- @field point Vector3 The impact point in world space where the ray hit the collider.
--- @field textureCoord Vector2 The uv texture coordinate at the collision location.
--- @field textureCoord2 Vector2 The secondary uv texture coordinate at the impact point.
--- @field transform Transform The Transform of the rigidbody or collider that was hit.
--- @field triangleIndex number The index of the triangle that was hit.
RaycastHit = {}

--- ##### Type *Rect*
--- ***
--- A 2D Rectangle defined by X and Y position, width and height.
--- @class Rect
--- @field center Vector2 The position of the center of the rectangle.
--- @field height number The height of the rectangle, measured from the Y position.
--- @field max Vector2 The position of the maximum corner of the rectangle.
--- @field min Vector2 The position of the minimum corner of the rectangle.
--- @field position Vector2 The X and Y position of the rectangle.
--- @field size Vector2 The width and height of the rectangle.
--- @field width number The width of the rectangle, measured from the X position.
--- @field x number The X coordinate of the rectangle.
--- @field xMax number The maximum X coordinate of the rectangle.
--- @field xMin number The minimum X coordinate of the rectangle.
--- @field y number The Y coordinate of the rectangle.
--- @field yMax number The maximum Y coordinate of the rectangle.
--- @field yMin number The minimum Y coordinate of the rectangle.
--- @field zero Rect **Static**  **Read-Only**  |  Shorthand for writing new Rect(0,0,0,0).
Rect = {}

--- ##### Constructor for *Rect*
--- ***
--- Creates a new rectangle.
--- @param x number The X value the rect is measured from.
--- @param y number The Y value the rect is measured from.
--- @param width number The width of the rectangle.
--- @param height number The height of the rectangle.
--- @return Rect
function Rect(x, y, width, height) end

--- ##### Constructor for *Rect*
--- ***
--- Creates a rectangle given a size and position.
--- @param position Vector2 The position of the minimum corner of the rect.
--- @param size Vector2 The width and height of the rect.
--- @return Rect
function Rect(position, size) end

--- ##### Method
--- ***
--- Returns true if the x and y components of point is a point inside this rectangle.
--- @param point Vector2 Point to test.
--- @return boolean # True if the point lies within the specified rectangle.
function Rect.Contains(point) end

--- ##### Method
--- ***
--- Returns true if the x and y components of point is a point inside this rectangle.
--- @param point Vector3 Point to test.
--- @return boolean # True if the point lies within the specified rectangle.
function Rect.Contains(point) end

--- ##### Method
--- ***
--- Returns true if the x and y components of point is a point inside this rectangle. If allowInverse is present and true, the width and height of the Rect are allowed to take negative values (ie, the min value is greater than the max), and the test will still work.
--- @param point Vector3 Point to test.
--- @param allowInverse boolean Does the test allow the Rect's width and height to be negative?
--- @return boolean # True if the point lies within the specified rectangle.
function Rect.Contains(point, allowInverse) end

--- ##### Method
--- ***
--- Returns true if the other rectangle overlaps this one.
--- @param other Rect Other rectangle to test overlapping with.
--- @return boolean # true if the other rectangle overlaps this one.
function Rect.Overlaps(other) end

--- ##### Method
--- ***
--- Returns true if the other rectangle overlaps this one. If allowInverse is present and true, the widths and heights of the Rects are allowed to take negative values (ie, the min value is greater than the max), and the test will still work.
--- @param other Rect Other rectangle to test overlapping with.
--- @param allowInverse boolean Does the test allow the widths and heights of the Rects to be negative?
--- @return boolean # True if the other rectangle overlaps this one
function Rect.Overlaps(other, allowInverse) end

--- ##### Method
--- ***
--- Set components of an existing Rect.
--- @param x number x
--- @param y number y
--- @param width number width
--- @param height number height
function Rect.Set(x, y, width, height) end

--- ##### Static Method
--- ***
--- Creates a rectangle from min/max coordinate values.
--- @param xmin number The minimum X coordinate.
--- @param ymin number The minimum Y coordinate.
--- @param xmax number The maximum X coordinate.
--- @param ymax number The maximum Y coordinate.
--- @return Rect # A rectangle matching the specified coordinates.
function Rect:MinMaxRect(xmin, ymin, xmax, ymax) end

--- ##### Static Method
--- ***
--- Returns a point inside a rectangle, given normalized coordinates.
--- @param rectangle	 Rect Rectangle to get a point inside.
--- @param normalizedRectCoordinates Vector2 Normalized coordinates to get a point for.
--- @return Vector2 # point inside a rectangle, given normalized coordinates.
function Rect:NormalizedToPoint(rectangle	, normalizedRectCoordinates) end

--- ##### Static Method
--- ***
--- Returns the normalized coordinates cooresponding the the point.
--- @param rectangle Rect Rectangle to get normalized coordinates inside.
--- @param point Vector2 A point inside the rectangle to get normalized coordinates for.
--- @return Vector2 # normalized coordinates cooresponding the the point.
function Rect:PointToNormalized(rectangle, point) end

--- ##### Type *Renderer* inherits *Component*
--- ***
--- General functionality for all renderers. Based on [Unity Renderer](https://docs.unity3d.com/2019.4/Documentation/ScriptReference/Renderer.html)
--- @class Renderer
--- @field allowOcclusionWhenDynamic boolean Controls if dynamic occlusion culling should be performed for this renderer.
--- @field bounds Bounds The bounding volume of the renderer (Read Only).
--- @field enabled boolean Makes the rendered 3D object visible if enabled.
--- @field forceRenderingOff boolean Allows turning off rendering for a specific component.
--- @field isPartOfStaticBatch boolean Has this renderer been statically batched with any other renderers? (Read-Only)
--- @field isVisible boolean Is this renderer visible in any camera? (Read Only)
--- @field lightmapIndex number The index of the baked lightmap applied to this renderer. (Read-Only)
--- @field lightmapScaleOffset Vector4 The UV scale & offset used for a lightmap. (Read-Only)
--- @field lightProbeProxyVolumeOverride GameObject If set, the Renderer will use the Light Probe Proxy Volume component attached to the source GameObject.
--- @field lightProbeUsage LightProbeUsage The light probe interpolation type.
--- @field localToWorldMatrix Matrix4x4 Matrix that transforms a point from local space into world space (Read Only).
--- @field material Material Returns the first instantiated Material assigned to the renderer. Modifying material will change the material for this object only.
--- @field materials Material[] Returns all the instantiated materials of this object.
--- @field motionVectorGenerationMode MotionVectorGenerationMode Specifies the mode for motion vector rendering.
--- @field probeAnchor Transform If set, Renderer will use this Transform's position to find the light or reflection probe. Otherwise the center of Renderer's AABB will be used.
--- @field realtimeLightmapIndex number The index of the realtime lightmap applied to this renderer.
--- @field realtimeLightmapScaleOffset Vector4 The UV scale & offset used for a realtime lightmap.
--- @field receiveShadows boolean Does this object receive shadows?
--- @field reflectionProbeUsage ReflectionProbeUsage Should reflection probes be used for this Renderer?
--- @field rendererPriority number This value sorts renderers by priority. Lower values are rendered first and higher values are rendered last.
--- @field renderingLayerMask number Determines which rendering layer this renderer lives on.
--- @field shadowCastingMode shadowCastingMode Does this object cast shadows?
--- @field sharedMaterial Material The shared material of this object.
--- @field sharedMaterials Material[] All the shared materials of this object.
--- @field sortingLayerID number Unique ID of the Renderer's sorting layer.
--- @field sortingLayerName string Name of the Renderer's sorting layer.
--- @field sortingOrder number Renderer's order within a sorting layer.
--- @field worldToLocalMatrix Matrix4x4 Matrix that transforms a point from world space into local space (Read Only).
--- @field gameObject GameObject **Read-Only**  **Inherited**  |  The game object this component is attached to. A component is always attached to a game object.
--- @field tag string **Read-Only**  **Inherited**  |  The tag of this game object.
--- @field transform Transform **Read-Only**  **Inherited**  |  The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
Renderer = {}

--- ##### Method
--- ***
--- Returns all the instantiated materials of this object.
--- @return Material # all the instantiated materials of this object.
function Renderer.GetMaterials() end

--- ##### Method
--- ***
--- Get per-Renderer or per-Material property block.
--- @param materialIndex number? **Optional**(default = -1) The index of the Material you want to get overridden parameters from. The index ranges from 0 to #Renderer.sharedMaterials-1.
--- @return MaterialPropertyBlock # per-Renderer or per-Material property block.
function Renderer.GetPropertyBlock(materialIndex) end

--- ##### Method
--- ***
--- Returns all the shared materials of this object.
--- @return Material[] # all the shared materials of this object.
function Renderer.GetSharedMaterials() end

--- ##### Method
--- ***
--- Returns true if the Renderer has a material property block attached via SetPropertyBlock.
--- @return boolean # true if the Renderer has a material property block attached via SetPropertyBlock.
function Renderer.HasPropertyBlock() end

--- ##### Method
--- ***
--- Lets you set or clear per-renderer or per-material parameter overrides.
--- @param properties MaterialPropertyBlock Property block with values you want to override.
--- @param materialIndex number? **Optional**(default = -1) The index of the Material you want to override the parameters of. The index ranges from 0 to #Renderer.sharedMaterial-1.
function Renderer.SetPropertyBlock(properties, materialIndex) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object or any of its children.
--- @param methodName string Name of the method to call.
--- @param parameter any? **Optional**(default = nil) Optional parameter to pass to the method (can be any value).
function Renderer.BroadcastMessage(methodName, parameter) end

--- ##### Method Inherited from *Component*
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function Renderer.CompareTag(tag) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # Array of all Lua scripts that attached to the game object.
function Renderer.GetAllLuaScripts() end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type if the game object has one attached, nil if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # the component of Type type
function Renderer.GetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function Renderer.GetComponentInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function Renderer.GetComponentInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function Renderer.GetComponents(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function Renderer.GetComponentsInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function Renderer.GetComponentsInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object. 
--- @param methodName string Name of the method to call.
--- @param value any? **Optional**(default = nil) Optional parameter for the method.
function Renderer.SendMessage(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every LuaScript in this game object and on every ancestor of the behaviour.
--- @param methodName string Name of method to call.
--- @param value any? **Optional**(default = nil) Optional parameter value for the method.
function Renderer.SendMessageUpwards(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of the component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or nil.
function Renderer.TryGetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function Renderer.GetInstanceID() end

--- ##### Type *RenderSettings*
--- ***
--- The Render Settings contain values for a range of visual elements in your Scene, like fog and ambient light. Based on [Unity RenderSettings](https://docs.unity3d.com/2019.4/Documentation/ScriptReference/RenderSettings.html)
--- @class RenderSettings
--- @field ambientEquatorColor Color **Static**  |  Ambient lighting coming from the sides.
--- @field ambientGroundColor Color **Static**  |  Ambient lighting coming from below.
--- @field ambientIntensity number How much the light from the Ambient Source affects the Scene.
--- @field ambientLight Color **Static**  |  Flat ambient lighting color.
--- @field ambientMode AmbientMode **Static**  |  Ambient lighting mode.
--- @field ambientSkyColor Color **Static**  |  Ambient lighting coming from above.
--- @field defaultReflectionResolution number **Static**  |  Cubemap resolution for default reflection.
--- @field flareFadeSpeed number **Static**  |  The fade speed of all flares in the Scene.
--- @field flareStrength number **Static**  |  The intensity of all flares in the Scene.
--- @field fog boolean **Static**  |  Is fog enabled?
--- @field fogColor Color **Static**  |  The color of the fog.
--- @field fogDensity number **Static**  |  The density of the exponential fog.
--- @field fogEndDistance number **Static**  |  The ending distance of linear fog.
--- @field fogMode FogMode **Static**  |  Fog mode to use.
--- @field fogStartDistance number **Static**  |  
--- @field haloStrength number **Static**  |  Size of the Light halos.
--- @field reflectionBounces number **Static**  |  The number of times a reflection includes other reflections.
--- @field reflectionIntensity number **Static**  |  How much the skybox / custom cubemap reflection affects the Scene.
--- @field skybox Material **Static**  |  The global skybox to use.
--- @field subtractiveShadowColor Color **Static**  |  The color used for the sun shadows in the Subtractive lightmode.
--- @field sun Light **Static**  |  The light used by the procedural skybox. If none, the brightest directional light is used.
RenderSettings = {}

--- ##### Type *Rigidbody* inherits *Component*
--- ***
--- Control of an object's position through physics simulation. [Unity Rigidbody](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/Rigidbody.html)
--- @class Rigidbody
--- @field angularDrag number The angular drag of the object.
--- @field angularVelocity Vector3 The angular velocity vector of the rigidbody measured in radians per second.
--- @field centerOfMass Vector3 The center of mass relative to the transform's origin.
--- @field collisionDetectionMode CollisionDetectionMode The Rigidbody's collision detection mode.
--- @field constraints RigidbodyConstraints Controls which degrees of freedom are allowed for the simulation of this Rigidbody.
--- @field detectCollisions boolean Should collision detection be enabled? (By default always enabled).
--- @field drag number The drag of the object.
--- @field freezeRotation boolean Controls whether physics will change the rotation of the object.
--- @field inertiaTensor Vector3 The diagonal inertia tensor of mass relative to the center of mass.
--- @field inertiaTensorRotation Quaternion The rotation of the inertia tensor.
--- @field interpolation RigidbodyInterpolation Interpolation allows you to smooth out the effect of running physics at a fixed frame rate.
--- @field isKinematic boolean Controls whether physics affects the rigidbody.
--- @field mass number The mass of the rigidbody.
--- @field maxAngularVelocity number The maximimum angular velocity of the rigidbody measured in radians per second. (Default 7) range { 0, infinity }.
--- @field maxDepenetrationVelocity number Maximum velocity of a rigidbody when moving out of penetrating state.
--- @field position Vector3 The position of the rigidbody.
--- @field rotation Quaternion The rotation of the Rigidbody.
--- @field sleepThreshold number The mass-normalized energy threshold, below which objects start going to sleep.
--- @field solverIterations number The solverIterations determines how accurately Rigidbody joints and collision contacts are resolved. Overrides Physics.defaultSolverIterations. Must be positive.
--- @field solverVelocityIterations number The solverVelocityIterations affects how how accurately Rigidbody joints and collision contacts are resolved. Overrides Physics.defaultSolverVelocityIterations. Must be positive.
--- @field useGravity boolean Controls whether gravity affects this rigidbody.
--- @field velocity Vector3 The velocity vector of the rigidbody. It represents the rate of change of Rigidbody position.
--- @field worldCenterOfMass Vector3 The center of mass of the rigidbody in world space (Read Only).
--- @field gameObject GameObject **Read-Only**  **Inherited**  |  The game object this component is attached to. A component is always attached to a game object.
--- @field tag string **Read-Only**  **Inherited**  |  The tag of this game object.
--- @field transform Transform **Read-Only**  **Inherited**  |  The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
Rigidbody = {}

--- ##### Method
--- ***
--- Applies a force to a rigidbody that simulates explosion effects.
--- @param explosionForce number The force of the explosion (which may be modified by distance).
--- @param explosionPosition Vector3 The centre of the sphere within which the explosion has its effect.
--- @param explosionRadius number The radius of the sphere within which the explosion has its effect.
--- @param upwardsModifier number? **Optional**(default = 0) Adjustment to the apparent position of the explosion to make it seem to lift objects.
--- @param mode ForceMode? **Optional**(default = ForceMode.Force) The method used to apply the force to its targets.
function Rigidbody.AddExplosionForce(explosionForce, explosionPosition, explosionRadius, upwardsModifier, mode) end

--- ##### Method
--- ***
--- Adds a force to the Rigidbody.
--- @param force Vector3 Force vector in world coordinates.
--- @param mode ForceMode? **Optional**(default = ForceMode.Force) Type of force to apply.
function Rigidbody.AddForce(force, mode) end

--- ##### Method
--- ***
--- Applies force at position. As a result this will apply a torque and force on the object.
--- @param force Vector3 Force vector in world coordinates.
--- @param position Vector3 Position in world coordinates.
--- @param mode ForceMode? **Optional**(default = ForceMode.Force) 
function Rigidbody.AddForceAtPosition(force, position, mode) end

--- ##### Method
--- ***
--- Adds a force to the rigidbody relative to its coordinate system.
--- @param force Vector3 Force vector in local coordinates.
--- @param mode ForceMode? **Optional**(default = ForceMode.Force) 
function Rigidbody.AddRelativeForce(force, mode) end

--- ##### Method
--- ***
--- Adds a torque to the rigidbody relative to its coordinate system.
--- @param torque Vector3 Torque vector in local coordinates.
--- @param mode ForceMode? **Optional**(default = ForceMode.Force) 
function Rigidbody.AddRelativeTorque(torque, mode) end

--- ##### Method
--- ***
--- Adds a torque to the rigidbody.
--- @param torque Vector3 Torque vector in world coordinates.
--- @param mode ForceMode? **Optional**(default = ForceMode.Force) 
function Rigidbody.AddTorque(torque, mode) end

--- ##### Method
--- ***
--- The closest point to the bounding box of the attached colliders.
--- @param position Vector3 
--- @return Vector3 # closest point to the bounding box of the attached colliders.
function Rigidbody.ClosestPointOnBounds(position) end

--- ##### Method
--- ***
--- The velocity of the rigidbody at the point worldPoint in global space.
--- @param worldPoint Vector3 
--- @return Vector3 # The velocity of the rigidbody at the point worldPoint in global space.
function Rigidbody.GetPointVelocity(worldPoint) end

--- ##### Method
--- ***
--- The velocity relative to the rigidbody at the point relativePoint.
--- @param relativePoint Vector3 
--- @return Vector3 # The velocity relative to the rigidbody at the point relativePoint.
function Rigidbody.GetRelativePointVelocity(relativePoint) end

--- ##### Method
--- ***
--- Is the rigidbody sleeping?
--- @return boolean # Is the rigidbody sleeping?
function Rigidbody.IsSleeping() end

--- ##### Method
--- ***
--- Moves the kinematic Rigidbody towards position.
--- @param position Vector3 Provides the new position for the Rigidbody object.
function Rigidbody.MovePosition(position) end

--- ##### Method
--- ***
--- Rotates the rigidbody to rotation.
--- @param rot Quaternion The new rotation for the Rigidbody.
function Rigidbody.MoveRotation(rot) end

--- ##### Method
--- ***
--- Reset the center of mass of the rigidbody.
function Rigidbody.ResetCenterOfMass() end

--- ##### Method
--- ***
--- Reset the inertia tensor value and rotation.
function Rigidbody.ResetInertiaTensor() end

--- ##### Method
--- ***
--- Sets the mass based on the attached colliders assuming a constant density.
--- @param density number 
function Rigidbody.SetDensity(density) end

--- ##### Method
--- ***
--- Forces a rigidbody to sleep at least one frame.
function Rigidbody.Sleep() end

--- ##### Method
--- ***
--- Tests if a rigidbody would collide with anything, if it was moved through the Scene.
--- @param direction Vector3 The direction into which to sweep the rigidbody.
--- @param maxDistance number? **Optional**(default = math.huge) The length of the sweep.
--- @param queryTriggerInteraction QueryTriggerInteraction? **Optional**(default = QueryTriggerInteraction.UseGlobal) Specifies whether this query should hit Triggers.
--- @return boolean # True when the rigidbody sweep intersects any collider, otherwise false.
--- @return RaycastHit # If true is returned, hitInfo will contain more information about where the collider was hit 
function Rigidbody.SweepTest(direction, maxDistance, queryTriggerInteraction) end

--- ##### Method
--- ***
--- Like Rigidbody.SweepTest, but returns all hits.
--- @param direction Vector3 The direction into which to sweep the rigidbody.
--- @param maxDistance number? **Optional**(default = math.huge) The length of the sweep.
--- @param queryTriggerInteraction QueryTriggerInteraction? **Optional**(default = QueryTriggerInteraction.UseGlobal) Specifies whether this query should hit Triggers.
--- @return RaycastHit[] # An array of all colliders hit in the sweep.
function Rigidbody.SweepTestAll(direction, maxDistance, queryTriggerInteraction) end

--- ##### Method
--- ***
--- Forces a rigidbody to wake up.
function Rigidbody.WakeUp() end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object or any of its children.
--- @param methodName string Name of the method to call.
--- @param parameter any? **Optional**(default = nil) Optional parameter to pass to the method (can be any value).
function Rigidbody.BroadcastMessage(methodName, parameter) end

--- ##### Method Inherited from *Component*
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function Rigidbody.CompareTag(tag) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # Array of all Lua scripts that attached to the game object.
function Rigidbody.GetAllLuaScripts() end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type if the game object has one attached, nil if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # the component of Type type
function Rigidbody.GetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function Rigidbody.GetComponentInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function Rigidbody.GetComponentInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function Rigidbody.GetComponents(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function Rigidbody.GetComponentsInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function Rigidbody.GetComponentsInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object. 
--- @param methodName string Name of the method to call.
--- @param value any? **Optional**(default = nil) Optional parameter for the method.
function Rigidbody.SendMessage(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every LuaScript in this game object and on every ancestor of the behaviour.
--- @param methodName string Name of method to call.
--- @param value any? **Optional**(default = nil) Optional parameter value for the method.
function Rigidbody.SendMessageUpwards(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of the component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or nil.
function Rigidbody.TryGetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function Rigidbody.GetInstanceID() end

--- ##### Type *Room*
--- ***
--- Manage and access information about current room. Each session of an SDK world is called Room. The players belonging to the same room, can see each other, hear each other, and synchronously effected by the events happening in the said room. 
--- @class Room
--- @field OnAudioChannelUpdate RoomOnAudioChannelUpdateEventHandler **Event** **Static** | Called when channel policy gets updated on the server.
--- @field OnPlayerJoin RoomOnPlayerJoinEventHandler **Event** **Static** | Event handler that gets invoked when a new player joins the room.  
--- @field OnPlayerLeft RoomOnPlayerLeftEventHandler **Event** **Static** | Event handler that gets invoked when a player leaves the room. 
--- @field PlayerCount number **Static**  **Read-Only**  |  Number of players in current room.
Room = {}

--- ##### Static Method
--- ***
--- Looks for the player in room with specific actor id.
--- @param ActorID number ActorID of the player.
--- @return MLPlayer # The player if found, Nil otherwise.
function Room:FindPlayerByActorNumber(ActorID) end

--- ##### Static Method
--- ***
--- Finds player with the given Guid. 
--- @param guid string The player guid to search for.
--- @return MLPlayer # The Player with given guid if found. Nil otherwise.
function Room:FindPlayerByGuid(guid) end

--- ##### Static Method
--- ***
--- Looks for the player in room with a specific name.
--- @param name string Name of the player.
--- @return MLPlayer # The player if found, Nil otherwise.
function Room:FindPlayerByName(name) end

--- ##### Static Method
--- ***
--- Looks for the player in room with specific network id.
--- @param NetworkID number Network ID of player.
--- @return MLPlayer # The player if found, Nil otherwise.
function Room:FindPlayerByNetworkID(NetworkID) end

--- ##### Static Method
--- ***
--- Looks for the player which is closest to the specified location. 
--- @param location Vector3 Specified location.
--- @return MLPlayer # The closes player to the location.
function Room:FindPlayerCloseToPosition(location) end

--- ##### Static Method
--- ***
--- Finds list of players which are inside the specified cubic volume defined by bounds.
--- @param bounds Bounds The Bounds defining the cubic volume.
--- @return MLPlayer[] # List of players which are inside the specified cubic volume 
function Room:FindPlayersInBounds(bounds) end

--- ##### Static Method
--- ***
--- Finds list of players which are inside the specified collider. Uses the volume defined by Bounds of the collider. Same as `FindPlayersInBounds`.
--- @param collider  Collider Collider 
--- @return MLPlayer[] # List of players which are inside the specified collider
function Room:FindPlayersInCollider(collider ) end

--- ##### Static Method
--- ***
--- Finds list of players which are inside the specified spherical volume defined by center and radius.
--- @param center Vector3 The center of the spherical volume.
--- @param radius number The radius of the spherical volume.
--- @return MLPlayer[] # List of players which are inside the specified spherical volume 
function Room:FindPlayersInsideVolume(center, radius) end

--- ##### Static Method
--- ***
--- Returns an array of all players in current room.
--- @return MLPlayer[] # array of all players in current room.
function Room:GetAllPlayers() end

--- ##### Static Method
--- ***
--- Gets the channel policy of the specified channel, if it exists.
--- @param channelID number The channel to retrieve. Range[0-255]
--- @return MLAudioChannelPolicy # the channel policy of the specified channelID if exits, nil otherwise
function Room:GetChannelPolicy(channelID) end

--- ##### Static Method
--- ***
--- Returns the local player. The local player means the player that is getting controlled by this running client.			
--- @return MLPlayer # The local player.
function Room:GetLocalPlayer() end

--- ##### Static Method
--- ***
--- Assigns a function to run once for every player object when instantiated. This include the local player, players that were in the room before the local player, and for any player who will join later. The function will be triggered after the full instantiation of the player, so all the player components are present. The function will provide the related [MLPlayer]( https://sdk.massiveloop.com/api/MLPlayer/index.html) object.
--- @param _function function The function to run for every player object.
function Room:RunForAnyPlayer(_function) end

--- ##### Static Method
--- ***
--- Create a channel with the given channel policy if it doesn't exist. Otherwise, updates the channel policy. Changes become active not immediately but when the server executes this operation (approximately RTT/2).
--- @param channelID number Channel ID range [0 - 255].
--- @param channelPolicy MLAudioChannelPolicy Channel policy to be used for this channel.
--- @return boolean # true if operation could be sent to the server, otherwise false, also return false if channel policy is null.
function Room:TryCreateOrUpdateChannel(channelID, channelPolicy) end

--- ##### Static Method
--- ***
--- Gets the channel policy of the specified channel, if it exists.
--- @param channelID number The channel to retrieve. Range[0-255]
--- @return boolean # true if the channel is found, false otherwise
--- @return MLAudioChannelPolicy # the channel policy or nil
function Room:TryGetChannelPolicy(channelID) end

--- ##### Static Method
--- ***
--- Remove a channel, if it exists.
--- @param channelID number The channel to remove.
--- @return boolean # true if the operation could be sent to the server. False if channel doesn't exists.
function Room:TryRemoveChannel(channelID) end

--- ##### Type
--- ***
--- Event Handler
--- @class RoomOnAudioChannelUpdateEventHandler : EventHandler
RoomOnAudioChannelUpdateEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun(channelPolicy : MLAudioChannelPolicy)  Function to registered
function RoomOnAudioChannelUpdateEventHandler.Add(handler)end

--- ##### Type
--- ***
--- Event Handler
--- @class RoomOnPlayerJoinEventHandler : EventHandler
RoomOnPlayerJoinEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun(player : MLPlayer)  Function to registered
function RoomOnPlayerJoinEventHandler.Add(handler)end

--- ##### Type
--- ***
--- Event Handler
--- @class RoomOnPlayerLeftEventHandler : EventHandler
RoomOnPlayerLeftEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun(player : MLPlayer)  Function to registered
function RoomOnPlayerLeftEventHandler.Add(handler)end

--- ##### Type *RuntimeAnimatorController* inherits *Object*
--- ***
--- The runtime representation of the AnimatorController. Use this representation to change the Animator Controller during runtime.
--- @class RuntimeAnimatorController
--- @field animationClips AnimationClip[] Retrieves all AnimationClip used by the controller.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
RuntimeAnimatorController = {}

--- ##### Method Inherited from *Object*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function RuntimeAnimatorController.GetInstanceID() end

--- ##### Type *Scene*
--- ***
--- Run-time data structure for *.unity file. [Unity Scene](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/SceneManagement.Scene.html)
--- @class Scene
--- @field buildIndex number Return the index of the Scene in the Build Settings.
--- @field isDirty boolean Returns true if the Scene is modifed.
--- @field isLoaded boolean Returns true if the Scene is loaded.
--- @field name string Returns the name of the Scene that is currently active in the game or app.
--- @field path string Returns the relative path of the Scene. Like: "Assets/MyScenes/MyScene.unity".
--- @field rootCount number 
Scene = {}

--- ##### Method
--- ***
--- Returns all the root game objects in the Scene.
function Scene.GetRootGameObjects() end

--- ##### Method
--- ***
--- Whether this is a valid Scene. A Scene may be invalid if, for example, you tried to open a Scene that does not exist. In this case, the Scene returned from EditorSceneManager.OpenScene would return False for IsValid. 
--- @return boolean # Whether this is a valid Scene.
function Scene.IsValid() end

--- ##### Type *ScoreBoardEntry*
--- ***
--- An entry for scoreboard. Contains information about the player and their score.
--- @class ScoreBoardEntry
--- @field Name string The name of the score. Like kills, health, etc. 
--- @field UserDisplayName string **Read-Only**  |  The Display name of the user which this score is associated with.
--- @field UserId string **Read-Only**  |  The id of the user which this score is associated with.
--- @field Value number The score value. 
ScoreBoardEntry = {}

--- ##### Constructor for *ScoreBoardEntry*
--- ***
--- Creates a new scoreboard entry.
--- @param player MLPlayer Associated player
--- @param name string The name of the score. Like kills, health, etc. 
--- @param value number The score value. 
--- @return ScoreBoardEntry
function ScoreBoardEntry(player, name, value) end

--- **Deprecated!**(Use [LuaBehaviour](../LuaBehaviour/index.html))
--- ***
--- ##### Type *Script*
--- ***
--- The script object references the Lua script that is attached to the game object. From the script, you access the underlying game object and the callback functions.
--- @deprecated deprecated type
--- @class Script
--- @field gameObject GameObject **Read-Only**  |  The GameObejct which this script attached to.  
--- @field id string **Read-Only**  |  A Unique identifier for this Lua script. This id is same for this script for all the clients in the room.
--- @field FixedUpdate fun() # **Message** | Frame-rate independent FixedUpdate message for physics calculations. [Similar to Unity Fixed Update](https://docs.unity3d.com/ScriptReference/MonoBehaviour.FixedUpdate.html)
--- @field LateUpdate fun() # **Message** | LateUpdate is called after all Update functions have been called.
--- @field OnBecomeOwner fun() # **Message** | Called when the current client becomes the owner of the object.
--- @field OnLostOwnership fun() # **Message** | Called when the current client loses the network ownership of the object. 
--- @field OnOwnerChanged fun(player : MLPlayer) # **Message** | OnOwnerChanged called when the current Network owner is changed. The new owner is passed as argument. Network ownership allows a certain client to modify properties of a game object if that game object or any of its parent or grandparents are synchronized using MLSynchronizer.
--- @field Start fun() # **Message** | Called once at the beginning of the game.
--- @field Update fun() # **Message** | Called once every frame.
Script = {}

--- ##### Method
--- ***
--- Returns the component of Type type if the game object has one attached, null if it doesn't.
--- @param type userdata The type of Component to retrieve.
--- @return Component # component of Type
function Script.GetComponent(type) end

--- ##### Method
--- ***
--- Starts the passed function as a coroutine function.
--- @param coroutineFunction function The name of the function to be started as a coroutine. Must have at least one `coroutine.yield()` call with in it.
--- @param _args ... Arguments to passed as parameters to the coroutine function.
function Script.StartCoroutine(coroutineFunction, ...) end

--- **Deprecated!**()
--- ***
--- ##### Type *SDKGrab* inherits *Component*
--- ***
--- The Lua interface for SDKGrab component. Add this component to any object to make it grabbable. You can access to various events of the component.   
--- ##### example
--- How to get the component:
--- ```
--- do
--- 	local script = LUA.script;
--- 	local obj = script.gameObject;
--- 
--- 	local function onFire()
--- 		Debug.Log("Bang!");
--- 	end
--- 
--- 	function script.Start()
--- 		local grab = obj.GetComponent(SDKGrab);
--- 		grab.OnTriggerButon.Add(onFire);
--- 	end
--- 
--- 
--- end
--- ```
--- @deprecated deprecated type
--- @class SDKGrab
--- @field OnGrabBegin EventHandler Invokes when the player grabs the object.
--- @field OnGrabEnd EventHandler Invokes when the player releases the object. 
--- @field OnTriggerButon EventHandler Invokes when the player presses the trigger button on their controller while grabbing to the object.
--- @field OnTriggerRelease EventHandler Event handler which gets triggered when the trigger button is released.
--- @field gameObject GameObject **Read-Only**  **Inherited**  |  The game object this component is attached to. A component is always attached to a game object.
--- @field tag string **Read-Only**  **Inherited**  |  The tag of this game object.
--- @field transform Transform **Read-Only**  **Inherited**  |  The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
SDKGrab = {}

--- ##### Method
--- ***
--- Forcefully release the object from player’s hand.
function SDKGrab.ForceRelease() end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object or any of its children.
--- @param methodName string Name of the method to call.
--- @param parameter any? **Optional**(default = nil) Optional parameter to pass to the method (can be any value).
function SDKGrab.BroadcastMessage(methodName, parameter) end

--- ##### Method Inherited from *Component*
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function SDKGrab.CompareTag(tag) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # Array of all Lua scripts that attached to the game object.
function SDKGrab.GetAllLuaScripts() end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type if the game object has one attached, nil if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # the component of Type type
function SDKGrab.GetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function SDKGrab.GetComponentInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function SDKGrab.GetComponentInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function SDKGrab.GetComponents(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function SDKGrab.GetComponentsInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function SDKGrab.GetComponentsInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object. 
--- @param methodName string Name of the method to call.
--- @param value any? **Optional**(default = nil) Optional parameter for the method.
function SDKGrab.SendMessage(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every LuaScript in this game object and on every ancestor of the behaviour.
--- @param methodName string Name of method to call.
--- @param value any? **Optional**(default = nil) Optional parameter value for the method.
function SDKGrab.SendMessageUpwards(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of the component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or nil.
function SDKGrab.TryGetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function SDKGrab.GetInstanceID() end

--- ##### Type *SkeletonBone*
--- ***
--- Details of the Transform name mapped to the skeleton bone of a model and its default position and rotation in the T-pose.
--- @class SkeletonBone
--- @field name string The name of the Transform mapped to the bone.
--- @field position Vector3 The T-pose position of the bone in local space.
--- @field rotation Quaternion The T-pose rotation of the bone in local space.
--- @field scale Vector3 The T-pose scaling of the bone in local space.
SkeletonBone = {}

--- ##### Constructor for *SkeletonBone*
--- ***
--- Creates new SkeletonBone
--- @return SkeletonBone
function SkeletonBone() end

--- ##### Type *SphericalHarmonicsL2*
--- ***
--- Spherical harmonics up to the second order (3 bands, 9 coefficients). [Based On](https://docs.unity3d.com/2019.4/Documentation/ScriptReference/Rendering.SphericalHarmonicsL2.html)
--- @class SphericalHarmonicsL2
--- @field [rgb, coefficient] number Access individual SH coefficients.
SphericalHarmonicsL2 = {}

--- ##### Constructor for *SphericalHarmonicsL2*
--- ***
--- Create new SphericalHarmonicsL2.
--- @return SphericalHarmonicsL2
function SphericalHarmonicsL2() end

--- ##### Method
--- ***
--- Add ambient lighting to probe data. If SH probe is used to calculate lighting, this function has the effect of adding ambient light into probe data.
--- @param color Color The Color of light. 
function SphericalHarmonicsL2.AddAmbientLight(color) end

--- ##### Method
--- ***
--- Add directional light to probe data. If SH probe is used to calculate lighting, this function has the effect of adding directional light into probe data. 
--- @param direction Vector3 The direction of light.
--- @param color Color The color of light.
--- @param intensity number The intensity of the light.
function SphericalHarmonicsL2.AddDirectionalLight(direction, color, intensity) end

--- ##### Method
--- ***
--- Clears SH probe to zero. 
function SphericalHarmonicsL2.Clear() end

--- ##### Method
--- ***
--- Evaluates the Spherical Harmonics for each of the given directions. Directions must be normalized.
--- @param directions Vector3[] Normalized directions for which the spherical harmonics are to be evaluated.
--- @return Color[] # Output array for the evaluated values of the corresponding directions.
function SphericalHarmonicsL2.Evaluate(directions) end

--- ##### Type *SyncVar*
--- ***
--- Defines a Synchronized variable. Synchronized Variables are variables that their value is synchronized on all clients of a multiplayer session. This property makes them ideal for storing game and object states that synched in all clients and persist even after change in master client.  **Type of variables** Synchronized variables are flexible on type. They can adopt to the type of the input provided on `SyncSet` method. As a matter of fact, the type of the variable can be changed if needed. However, only the Serializable Types are properly synchronized. If a none-serializable type provided, it gets synchronized as a Nil.  Check out [Serializable Types](https://sdk.massiveloop.com/getting_started/scripting/SerializableTypes.html). **Size Limitation** There is a size limitation on variables, but it is only relevant to strings and arrays. Please keep size of the string variables and arrays as low as possible. The value of the Synchronized Variables with size bigger than 700 bytes are most likely to not serialized properly.  **Late Joiners**  The Massive Loop guarantees that the all the synchronized variables in the session is received and ready to use before the Lua scripts start.  
--- @class SyncVar
--- @field OnVariableChange SyncVarOnVariableChangeEventHandler **Event**  | Event handler that invokes when the value of the Synchronized variable changes by any clients.
--- @field OnVariableSet SyncVarOnVariableSetEventHandler **Event**  | Event handler called when the Sync variable set (even if still the same values set). 
SyncVar = {}

--- ##### Constructor for *SyncVar*
--- ***
--- Creates or links the existing synchronized variable. If the synchronized variable does not exist in the multiplayer sessions, it creates and returns a new variable, otherwise it returns the existing variable. 
--- @param script LuaBehaviour The Script object. Can be accessed from `LUA.script`. 
--- @param Name string Name of the variable.
--- @param global boolean? **Optional**(default = false) Optional global value makes the synchronized variable accessible in every script if set to true. Otherwise, the synchronized variables scope is limited to the same script in same game object. Like local vs global events.  
--- @return SyncVar
function SyncVar(script, Name, global) end

--- ##### Method
--- ***
--- Send the value of this variable to other clients again. You **do not** need to call this function to send the value of the variables to other. 
function SyncVar.Flush() end

--- ##### Method
--- ***
--- Retrieves the (synchronized) value of the Synchronized variable. 
--- @return any # Synchronized value of the variable. 
function SyncVar.SyncGet() end

--- ##### Method
--- ***
--- Sets the value of the variable and synchronizes it with other clients.
--- @param Value any The value of the synchronized variable. It must be a serializable type otherwise it will send it as a null. 
function SyncVar.SyncSet(Value) end

--- ##### Method
--- ***
--- Asks for latest value of the variable to sent to this client **again**. You **do not** need to call this function to receive the latest changes, the changes automatically received. However, in some rare cases it is needed to make sure the value is the latest.
function SyncVar.Update() end

--- ##### Static Method
--- ***
--- Checks if a synchronized variable with given name exists. 
--- @param script LuaBehaviour The script object. Can be accessed from `LUA.script`.
--- @param name string Name of variable. 
--- @param gloabl boolean? **Optional**(default = false) Check in global scope? 
--- @return boolean # Ture if the variable exists. 
function SyncVar:Exists(script, name, gloabl) end

--- ##### Static Method
--- ***
--- Flushes all the variables again. 
function SyncVar:FlushAll() end

--- ##### Static Method
--- ***
--- Updates all the variables again. Note that it will takes few frames for variables to be updated. Use `OnVariableChange` event handler.
function SyncVar:UpdateAll() end

--- ##### Type
--- ***
--- Event Handler
--- @class SyncVarOnVariableChangeEventHandler : EventHandler
SyncVarOnVariableChangeEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun(value : any)  Function to registered
function SyncVarOnVariableChangeEventHandler.Add(handler)end

--- ##### Type
--- ***
--- Event Handler
--- @class SyncVarOnVariableSetEventHandler : EventHandler
SyncVarOnVariableSetEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun(value : any)  Function to registered
function SyncVarOnVariableSetEventHandler.Add(handler)end

--- ##### Type *Text* inherits *Component*
--- ***
--- The default Graphic to draw font data to screen.
--- @class Text
--- @field alignByGeometry boolean Use the extents of glyph geometry to perform horizontal alignment rather than glyph metrics.
--- @field alignment TextAnchor The positioning of the text reliative to its RectTransform.
--- @field color Color The text color
--- @field fontSize number The size that the Font should render at.
--- @field fontStyle FontStyle FontStyle used by the text.
--- @field lineSpacing number Line spacing, specified as a factor of font line height. A value of 1 will produce normal line spacing.
--- @field supportRichText boolean Whether this Text will support rich text.
--- @field text string The string value this Text displays.
--- @field gameObject GameObject **Read-Only**  **Inherited**  |  The game object this component is attached to. A component is always attached to a game object.
--- @field tag string **Read-Only**  **Inherited**  |  The tag of this game object.
--- @field transform Transform **Read-Only**  **Inherited**  |  The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
Text = {}

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object or any of its children.
--- @param methodName string Name of the method to call.
--- @param parameter any? **Optional**(default = nil) Optional parameter to pass to the method (can be any value).
function Text.BroadcastMessage(methodName, parameter) end

--- ##### Method Inherited from *Component*
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function Text.CompareTag(tag) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # Array of all Lua scripts that attached to the game object.
function Text.GetAllLuaScripts() end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type if the game object has one attached, nil if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # the component of Type type
function Text.GetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function Text.GetComponentInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function Text.GetComponentInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function Text.GetComponents(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function Text.GetComponentsInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function Text.GetComponentsInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object. 
--- @param methodName string Name of the method to call.
--- @param value any? **Optional**(default = nil) Optional parameter for the method.
function Text.SendMessage(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every LuaScript in this game object and on every ancestor of the behaviour.
--- @param methodName string Name of method to call.
--- @param value any? **Optional**(default = nil) Optional parameter value for the method.
function Text.SendMessageUpwards(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of the component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or nil.
function Text.TryGetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function Text.GetInstanceID() end

--- ##### Type *TextMesh* inherits *Component*
--- ***
--- A script interface for the [text mesh component](https://docs.unity3d.com/2019.3/Documentation/Manual/class-TextMesh.html).
--- @class TextMesh
--- @field alignment TextAlignment How lines of text are aligned (Left, Right, Center).
--- @field anchor TextAnchor Which point of the text shares the position of the Transform.
--- @field characterSize number The size of each character (This scales the whole text).
--- @field color Color The color used to render the text.
--- @field fontSize number The font size to use (for dynamic fonts).
--- @field fontStyle FontStyle The font style to use (for dynamic fonts).
--- @field lineSpacing number How much space will be in-between lines of text.
--- @field offsetZ number How far should the text be offset from the transform.position.z when drawing.
--- @field richText boolean Enable HTML-style tags for Text Formatting Markup.
--- @field tabSize number How much space will be inserted for a tab '\t' character. This is a multiplum of the 'spacebar' character offset.
--- @field text string The text that is displayed.
--- @field gameObject GameObject **Read-Only**  **Inherited**  |  The game object this component is attached to. A component is always attached to a game object.
--- @field tag string **Read-Only**  **Inherited**  |  The tag of this game object.
--- @field transform Transform **Read-Only**  **Inherited**  |  The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
TextMesh = {}

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object or any of its children.
--- @param methodName string Name of the method to call.
--- @param parameter any? **Optional**(default = nil) Optional parameter to pass to the method (can be any value).
function TextMesh.BroadcastMessage(methodName, parameter) end

--- ##### Method Inherited from *Component*
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function TextMesh.CompareTag(tag) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # Array of all Lua scripts that attached to the game object.
function TextMesh.GetAllLuaScripts() end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type if the game object has one attached, nil if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # the component of Type type
function TextMesh.GetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function TextMesh.GetComponentInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function TextMesh.GetComponentInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function TextMesh.GetComponents(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function TextMesh.GetComponentsInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function TextMesh.GetComponentsInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object. 
--- @param methodName string Name of the method to call.
--- @param value any? **Optional**(default = nil) Optional parameter for the method.
function TextMesh.SendMessage(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every LuaScript in this game object and on every ancestor of the behaviour.
--- @param methodName string Name of method to call.
--- @param value any? **Optional**(default = nil) Optional parameter value for the method.
function TextMesh.SendMessageUpwards(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of the component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or nil.
function TextMesh.TryGetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function TextMesh.GetInstanceID() end

--- ##### Type *Texture* inherits *Object*
--- ***
--- Base class for Texture handling.
--- @class Texture
--- @field anisoLevel number Defines the anisotropic filtering level of the Texture.
--- @field dimension TextureDimension Dimensionality (type) of the Texture (Read Only).
--- @field filterMode FilterMode Filtering mode of the texture.
--- @field height number Height of the texture in pixels. (Read Only)
--- @field isReadable boolean Returns true if the Read/Write Enabled checkbox was checked when the texture was imported; otherwise returns false. For a dynamic Texture created from script, always returns true.  
--- @field mipMapBias number Mip map bias of the texture.
--- @field mipmapCount number How many mipmap levels are in this texture (Read Only).
--- @field updateCount number This counter is incremented when the texture is updated.
--- @field width number Width of the texture in pixels. (Read Only)
--- @field wrapMode TextureWrapMode Texture coordinate wrapping mode.
--- @field wrapModeU TextureWrapMode Texture U coordinate wrapping mode.
--- @field wrapModeV TextureWrapMode Texture V coordinate wrapping mode.
--- @field wrapModeW TextureWrapMode Texture W coordinate wrapping mode for Texture3D.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
Texture = {}

--- ##### Method Inherited from *Object*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function Texture.GetInstanceID() end

--- ##### Type *Time*
--- ***
--- Provides an interface to get time information from Unity. [Unity Time](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/Time.html)
--- @class Time
--- @field captureDeltaTime number **Static**  **Read-Only**  |  Slows game playback time to allow screenshots to be saved between frames.
--- @field captureFramerate number **Static**  **Read-Only**  |  The reciprocal of Time.captureDeltaTime.
--- @field deltaTime number **Static**  **Read-Only**  |  The completion time in seconds since the last frame (Read Only).
--- @field fixedDeltaTime number **Static**  **Read-Only**  |  The interval in seconds at which physics and other fixed frame rate updates (like MonoBehaviour's FixedUpdate) are performed.
--- @field fixedTime number **Static**  **Read-Only**  |  The time the latest FixedUpdate has started (Read Only). This is the time in seconds since the start of the game.
--- @field fixedUnscaledDeltaTime number **Static**  **Read-Only**  |  The timeScale-independent interval in seconds from the last fixed frame to the current one (Read Only).
--- @field fixedUnscaledTime number **Static**  **Read-Only**  |  The TimeScale-independant time the latest FixedUpdate has started (Read Only). This is the time in seconds since the start of the game.
--- @field frameCount number **Static**  **Read-Only**  |  
--- @field inFixedTimeStep boolean **Static**  **Read-Only**  |  Returns true if called inside a fixed time step callback (like MonoBehaviour's FixedUpdate), otherwise returns false.
--- @field maximumDeltaTime number **Static**  **Read-Only**  |  The maximum time a frame can take. Physics and other fixed frame rate updates (like MonoBehaviour's FixedUpdate) will be performed only for this duration of time per frame.
--- @field maximumParticleDeltaTime number **Static**  **Read-Only**  |  The maximum time a frame can spend on particle updates. If the frame takes longer than this, then updates are split into multiple smaller updates.
--- @field realtimeSinceStartup number **Static**  **Read-Only**  |  The real time in seconds since the game started (Read Only).
--- @field smoothDeltaTime number **Static**  **Read-Only**  |  A smoothed out Time.deltaTime (Read Only).
--- @field time number **Static**  **Read-Only**  |  The time at the beginning of this frame (Read Only). This is the time in seconds since the start of the game.
--- @field timeScale number **Static**  **Read-Only**  |  The scale at which time passes. This can be used for slow motion effects.
--- @field timeSinceLevelLoad number **Static**  **Read-Only**  |  The time this frame has started (Read Only). This is the time in seconds since the last level has been loaded.
--- @field unscaledDeltaTime number **Static**  **Read-Only**  |  The timeScale-independent interval in seconds from the last frame to the current one (Read Only).
--- @field unscaledTime number **Static**  **Read-Only**  |  The timeScale-independant time for this frame (Read Only). This is the time in seconds since the start of the game.
Time = {}

--- ##### Type *Transform* inherits *Component*
--- ***
--- Position, rotation and scale of an object. [Unity Transform](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/Transform.html)
--- @class Transform
--- @field childCount number **Read-Only**  |  The number of children the parent Transform has.
--- @field eulerAngles Vector3 The rotation as Euler angles in degrees.
--- @field forward Vector3 **Read-Only**  |  Returns a normalized vector representing the blue axis of the transform in world space.
--- @field hasChanged boolean Has the transform changed since the last time the flag was set to 'false'?
--- @field hierarchyCapacity number The transform capacity of the transform's hierarchy data structure.
--- @field hierarchyCount number The number of transforms in the transform's hierarchy data structure.
--- @field localEulerAngles Vector3 The rotation as Euler angles in degrees relative to the parent transform's rotation.
--- @field localPosition Vector3 Position of the transform relative to the parent transform.
--- @field localRotation Quaternion The rotation of the transform relative to the transform rotation of the parent.
--- @field localScale Vector3 The scale of the transform relative to the GameObjects parent.
--- @field lossyScale Vector3 **Read-Only**  |  The global scale of the object (Read Only).
--- @field parent Transform The parent of the transform.
--- @field position Vector3 The world space position of the Transform.
--- @field right Vector3 The red axis of the transform in world space.
--- @field root Transform Returns the topmost transform in the hierarchy.
--- @field rotation Quaternion 
--- @field up Vector3 The green axis of the transform in world space.
--- @field gameObject GameObject **Read-Only**  **Inherited**  |  The game object this component is attached to. A component is always attached to a game object.
--- @field tag string **Read-Only**  **Inherited**  |  The tag of this game object.
--- @field transform Transform **Read-Only**  **Inherited**  |  The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
Transform = {}

--- ##### Method
--- ***
--- Unparents all children.
function Transform.DetachChildren() end

--- ##### Method
--- ***
--- Finds a child by n and returns it.
--- @param n string Name of child to be found.
--- @return Transform # The returned child transform or null if no child is found.
function Transform.Find(n) end

--- ##### Method
--- ***
--- Returns a transform child by index.
--- @param index number Index of the child transform to return. Must be smaller than Transform.childCount. (integer) 
--- @return Transform # Transform child by index.
function Transform.GetChild(index) end

--- ##### Method
--- ***
--- Gets the sibling index.
--- @return number # sibling index.
function Transform.GetSiblingIndex() end

--- ##### Method
--- ***
--- Transforms a direction from world space to local space. The opposite of Transform.TransformDirection.
--- @param direction Vector3 direction
--- @return Vector3 # local space
function Transform.InverseTransformDirection(direction) end

--- ##### Method
--- ***
--- Transforms position from world space to local space.
--- @param position Vector3 position
--- @return Vector3 # local space.
function Transform.InverseTransformPoint(position) end

--- ##### Method
--- ***
--- Transforms a vector from world space to local space. The opposite of Transform.TransformVector.
--- @param vector Vector3 vector
--- @return Vector3 # local space
function Transform.InverseTransformVector(vector) end

--- ##### Method
--- ***
--- Is this transform a child of parent?
--- @param parent Transform parent
--- @return boolean # Is this transform a child of parent?
function Transform.IsChildOf(parent) end

--- ##### Method
--- ***
--- Rotates the transform so the forward vector points at /target/'s current position.
--- @param target Transform Object to point towards.
--- @param worldUp Vector3? **Optional**(default = Vector3.up) Vector specifying the upward direction.
function Transform.LookAt(target, worldUp) end

--- ##### Method
--- ***
--- Applies a rotation of eulerAngles.z degrees around the z-axis, eulerAngles.x degrees around the x-axis, and eulerAngles.y degrees around the y-axis (in that order).
--- @param eulers Vector3 The rotation to apply.
--- @param relativeTo Space? **Optional**(default = Space.Self) Determines whether to rotate the GameObject either locally to the GameObject or relative to the Scene in world space.
function Transform.Rotate(eulers, relativeTo) end

--- ##### Method
--- ***
--- Rotates the transform about axis passing through point in world coordinates by angle degrees.
--- @param point Vector3 point				
--- @param axis Vector3 axis
--- @param angle number angle
function Transform.RotateAround(point, axis, angle) end

--- ##### Method
--- ***
--- Move the transform to the start of the local transform list.
function Transform.SetAsFirstSibling() end

--- ##### Method
--- ***
--- Move the transform to the end of the local transform list.
function Transform.SetAsLastSibling() end

--- ##### Method
--- ***
--- Set the parent of the transform.
--- @param parent Transform The parent Transform to use.
function Transform.SetParent(parent) end

--- ##### Method
--- ***
--- Set the parent of the transform.
--- @param parent Transform The parent Transform to use.
--- @param worldPositionStays boolean If true, the parent-relative position, scale and rotation are modified such that the object keeps the same world space position, rotation and scale as before.
function Transform.SetParent(parent, worldPositionStays) end

--- ##### Method
--- ***
--- Sets the world space position and rotation of the Transform component.
--- @param position Vector3 position
--- @param rotation Quaternion rotation
function Transform.SetPositionAndRotation(position, rotation) end

--- ##### Method
--- ***
--- Sets the sibling index.
--- @param index number Index to set.
function Transform.SetSiblingIndex(index) end

--- ##### Method
--- ***
--- Transforms direction from local space to world space.
--- @param direction Vector3 direction
--- @return Vector3 # world space.
function Transform.TransformDirection(direction) end

--- ##### Method
--- ***
--- Transforms position from local space to world space.
--- @param position Vector3 position
--- @return Vector3 # world space
function Transform.TransformPoint(position) end

--- ##### Method
--- ***
--- Transforms vector from local space to world space.
--- @param vector Vector3 vector
--- @return Vector3 # world space.
function Transform.TransformVector(vector) end

--- ##### Method
--- ***
--- Moves the transform in the direction and distance of translation.
--- @param translation Vector3 translation
--- @param relativeTo Space? **Optional**(default = Space.Self) relativeTo
function Transform.Translate(translation, relativeTo) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object or any of its children.
--- @param methodName string Name of the method to call.
--- @param parameter any? **Optional**(default = nil) Optional parameter to pass to the method (can be any value).
function Transform.BroadcastMessage(methodName, parameter) end

--- ##### Method Inherited from *Component*
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function Transform.CompareTag(tag) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # Array of all Lua scripts that attached to the game object.
function Transform.GetAllLuaScripts() end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type if the game object has one attached, nil if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # the component of Type type
function Transform.GetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function Transform.GetComponentInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function Transform.GetComponentInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function Transform.GetComponents(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function Transform.GetComponentsInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function Transform.GetComponentsInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object. 
--- @param methodName string Name of the method to call.
--- @param value any? **Optional**(default = nil) Optional parameter for the method.
function Transform.SendMessage(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every LuaScript in this game object and on every ancestor of the behaviour.
--- @param methodName string Name of method to call.
--- @param value any? **Optional**(default = nil) Optional parameter value for the method.
function Transform.SendMessageUpwards(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of the component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or nil.
function Transform.TryGetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function Transform.GetInstanceID() end

--- ##### Type *UserInput*
--- ***
--- This is an object that holds the value of user input. 
--- @class UserInput
--- @field ALT boolean **Read-Only**  |  Desktop mode only, associated with button [Left Alt] in keyboard.
--- @field Crouch boolean **Read-Only**  |  Desktop mode only, associated with button [C] in keyboard.
--- @field CTRL boolean **Read-Only**  |  Desktop mode only, associated with button [Left Ctrl] in keyboard.
--- @field Jump boolean **Read-Only**  |  Desktop mode jump [Space] button is pressed.
--- @field KeyboardArrows Vector2 **Read-Only**  |  Arrow inputs from keyboard [up, down, left, right] when in Desktop Mode.
--- @field KeyboardMove Vector2 **Read-Only**  |  Move Inputs from keyboard [W,S,A,D] when in desktop mode. 
--- @field LeftControl Vector2 **Read-Only**  |  The left primary control vector2. In some controllers this is accomplished by trackpad, in others by a joystick. Returns values from keyboard buttons [W,S,A,D] while the client is in desktop mode. 
--- @field LeftGrab number **Read-Only**  |  The left controller grab button. It returns a value between 0 and 1, 1 being fully pressed. Associates to [q] button in desktop mode. 
--- @field LeftPrimary boolean **Read-Only**  |  Left controller primary button. Associated with [Space] button in keyboard while in desktop mode.
--- @field LeftSecondary boolean **Read-Only**  |  Left controller secondary button.
--- @field LeftSprint boolean **Read-Only**  |  The left sprint action. This action triggered differently in different controller types. In joystick-based controller this is accomplished by clicking the joystick. In trackpad-based controllers, this is accomplished by double taping the trackpad. Associated with [Left Shift] button in keyboard while in desktop mode.
--- @field LeftTrigger number **Read-Only**  |  Left trigger button. The trigger button is the button pressed by index finger. It returns a value between 0 and 1, 1 being fully pressed. Associates to [Left Mouse Button] while in desktop mode.
--- @field RightControl Vector2 **Read-Only**  |  The right primary control vector2. In some controllers this is accomplished by trackpad, in others by a joystick. Returns values from keyboard buttons [W,S,A,D] while the client is in desktop mode. 
--- @field RightGrab number **Read-Only**  |  The right controller grab button. It returns a value between 0 and 1, 1 being fully pressed. Associates to [e] button in desktop mode.
--- @field RightPrimary boolean **Read-Only**  |  Right controller primary button. Associated with [Space] button in keyboard while in desktop mode.
--- @field RightSecondary boolean **Read-Only**  |  Right controller secondary button. 
--- @field RightSprint boolean **Read-Only**  |  The right sprint action. This action triggered differently in different controller types. In joystick-based controller this is accomplished by clicking the joystick. In trackpad-based controllers, this is accomplished by double taping the trackpad. Associated with [Left Shift] button in keyboard while in desktop mode. 
--- @field RightTrigger number **Read-Only**  |  Right trigger button. The trigger button is the button pressed by index finger. It returns a value between 0 and 1, 1 being fully pressed. Associates to [Right Mouse Button] while in desktop mode.
UserInput = {}

--- ##### Type *Vector2*
--- ***
--- Representation of 2D vectors and points. [Unity Vector2](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/Vector2.html)
--- @class Vector2
--- @field down Vector2 **Static**  **Read-Only**  |  Shorthand for writing Vector2(0, -1).
--- @field left Vector2 **Static**  **Read-Only**  |  Shorthand for writing Vector2(-1, 0).
--- @field magnitude number **Read-Only**  |  Returns the length of this vector (Read Only).
--- @field negativeInfinity Vector2 **Static**  **Read-Only**  |  Shorthand for writing Vector2(float.NegativeInfinity, float.NegativeInfinity).
--- @field normalized Vector2 **Read-Only**  |  Returns this vector with a magnitude of 1 (Read Only).
--- @field one Vector2 **Static**  **Read-Only**  |  Shorthand for writing Vector2(1, 1).
--- @field positiveInfinity Vector2 **Static**  **Read-Only**  |  Shorthand for writing Vector2(float.PositiveInfinity, float.PositiveInfinity).
--- @field right Vector2 **Static**  **Read-Only**  |  Shorthand for writing Vector2(1, 0).
--- @field sqrMagnitude number **Read-Only**  |  Returns the squared length of this vector (Read Only).
--- @field up Vector2 **Static**  **Read-Only**  |  Shorthand for writing Vector2(0, 1).
--- @field x number X component of the vector.
--- @field y number Y component of the vector.
--- @field zero Vector2 **Static**  **Read-Only**  |  Shorthand for writing Vector2(0, 0).
--- @operator sub(Vector2) : Vector2 # Subtracts one vector from another.
--- @operator unm : Vector2 # Negates a vector. Each component in the result is negated.
--- @operator mul(number) : Vector2 # Multiplies a vector by a number.
--- @operator mul(Vector2) : Vector2 # Multiplies a vector by another vector. Multiplies each component of lhs by its matching component from rhs.
--- @operator div(number) : Vector2 # Divides a vector by a number.
--- @operator add(Vector2) : Vector2 # Adds two vectors. Adds corresponding components together.
Vector2 = {}

--- ##### Constructor for *Vector2*
--- ***
--- Constructs a new vector with given x, y components.
--- @param x number X component of the vector.
--- @param y number Y component of the vector.
--- @return Vector2
function Vector2(x, y) end

--- ##### Method
--- ***
--- Returns true if the given vector is exactly equal to this vector.
--- @param other table 
--- @return boolean # true if the given vector is exactly equal to this vector.
function Vector2.Equals(other) end

--- ##### Method
--- ***
--- Makes this vector have a magnitude of 1.
function Vector2.Normalize() end

--- ##### Method
--- ***
--- Set x and y components of an existing Vector2.
--- @param newX number newX
--- @param newY number newY
function Vector2.Set(newX, newY) end

--- ##### Static Method
--- ***
--- Returns the unsigned angle in degrees between from and to.
--- @param from Vector2 The vector from which the angular difference is measured.
--- @param to Vector2 The vector to which the angular difference is measured.
--- @return number # the unsigned angle in degrees between from and to.
function Vector2:Angle(from, to) end

--- ##### Static Method
--- ***
--- Returns a copy of vector with its magnitude clamped to maxLength.
--- @param vector Vector2 vector
--- @param maxLength number maxLength
--- @return Vector2 # a copy of vector with its magnitude clamped to maxLength.
function Vector2:ClampMagnitude(vector, maxLength) end

--- ##### Static Method
--- ***
--- Returns the distance between a and b.
--- @param a Vector2 a
--- @param b Vector2 b
--- @return number # distance between a and b.
function Vector2:Distance(a, b) end

--- ##### Static Method
--- ***
--- Dot Product of two vectors.
--- @param lhs Vector2 lhs
--- @param rhs Vector2 rhs
--- @return number # Dot Product of two vectors.
function Vector2:Dot(lhs, rhs) end

--- ##### Static Method
--- ***
--- Linearly interpolates between vectors a and b by t.
--- @param a Vector2 a
--- @param b Vector2 b
--- @param t number t
--- @return Vector2 # result
function Vector2:Lerp(a, b, t) end

--- ##### Static Method
--- ***
--- Linearly interpolates between vectors a and b by t.
--- @param a Vector2 a
--- @param b Vector2 b
--- @param t number t
--- @return Vector2 # result
function Vector2:LerpUnclamped(a, b, t) end

--- ##### Static Method
--- ***
--- Returns a vector that is made from the largest components of two vectors.
--- @param lhs Vector2 
--- @param rhs Vector2 
--- @return Vector2 # Max
function Vector2:Max(lhs, rhs) end

--- ##### Static Method
--- ***
--- Returns a vector that is made from the smallest components of two vectors.
--- @param lhs Vector2 
--- @param rhs Vector2 
--- @return Vector2 # Min
function Vector2:Min(lhs, rhs) end

--- ##### Static Method
--- ***
--- Moves a point current towards target.
--- @param current Vector2 
--- @param target Vector2 
--- @param maxDistanceDelta number 
--- @return Vector2 # result
function Vector2:MoveTowards(current, target, maxDistanceDelta) end

--- ##### Static Method
--- ***
--- Returns the 2D vector perpendicular to this 2D vector. The result is always rotated 90-degrees in a counter-clockwise direction for a 2D coordinate system where the positive Y axis goes up.
--- @param inDirection Vector2 The input direction.
--- @return Vector2 # The perpendicular direction.
function Vector2:Perpendicular(inDirection) end

--- ##### Static Method
--- ***
--- Reflects a vector off the vector defined by a normal.
--- @param inDirection Vector2 inDirection
--- @param inNormal Vector2 inNormal
--- @return Vector2 # result
function Vector2:Reflect(inDirection, inNormal) end

--- ##### Static Method
--- ***
--- Multiplies two vectors component-wise.
--- @param a Vector2 
--- @param b Vector2 
--- @return Vector2 # result
function Vector2:Scale(a, b) end

--- ##### Static Method
--- ***
--- Returns the signed angle in degrees between from and to.
--- @param from Vector2 The vector from which the angular difference is measured.
--- @param to Vector2 The vector to which the angular difference is measured.
--- @return number # the signed angle in degrees between from and to.
function Vector2:SignedAngle(from, to) end

--- ##### Type *Vector3*
--- ***
--- Representation of 3D vectors and points. [Unity Vector3](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/Vector3.html)
--- @class Vector3
--- @field back Vector3 **Static**  **Read-Only**  |  Shorthand for writing Vector3(0, 0, -1).
--- @field down Vector3 **Static**  **Read-Only**  |  Shorthand for writing Vector3(0, -1, 0).
--- @field forward Vector3 **Static**  **Read-Only**  |  Shorthand for writing Vector3(0, 0, 1).
--- @field left Vector3 **Static**  **Read-Only**  |  Shorthand for writing Vector3(-1, 0, 0).
--- @field magnitude number **Read-Only**  |  Returns the length of this vector (Read Only).
--- @field negativeInfinity Vector3 **Static**  **Read-Only**  |  Shorthand for writing Vector3(float.NegativeInfinity, float.NegativeInfinity, float.NegativeInfinity).
--- @field normalized Vector3 **Read-Only**  |  Returns this vector with a magnitude of 1 (Read Only).
--- @field one Vector3 **Static**  **Read-Only**  |  Shorthand for writing Vector3(1, 1, 1).
--- @field positiveInfinity Vector3 **Static**  **Read-Only**  |  Shorthand for writing Vector3(float.PositiveInfinity, float.PositiveInfinity, float.PositiveInfinity).
--- @field right Vector3 **Static**  **Read-Only**  |  Shorthand for writing Vector3(1, 0, 0).
--- @field sqrMagnitude number **Read-Only**  |  Returns the squared length of this vector (Read Only).
--- @field up Vector3 **Static**  **Read-Only**  |  Shorthand for writing Vector3(0, 1, 0).
--- @field x number X component of the vector.
--- @field y number Y component of the vector.
--- @field z number Z component of the vector.
--- @field zero Vector3 **Static**  **Read-Only**  |  Shorthand for writing Vector3(0, 0, 0).
--- @operator sub(Vector3) : Vector3 # Subtracts one vector from another.
--- @operator unm : Vector3 # Negates a vector. Each component in the result is negated.
--- @operator mul(number) : Vector3 # Multiplies a vector by a number.
--- @operator div(number) : Vector3 # Divides a vector by a number.
--- @operator add(Vector3) : Vector3 # Adds two vectors.
Vector3 = {}

--- ##### Constructor for *Vector3*
--- ***
--- Creates a new vector with given x, y, z components.
--- @param x number X component of the vector.
--- @param y number Y component of the vector.
--- @param z number Z component of the vector.
--- @return Vector3
function Vector3(x, y, z) end

--- ##### Method
--- ***
--- Set x, y and z components of an existing Vector3.
--- @param newX number new X
--- @param newY number new Y
--- @param newZ number new Z
function Vector3.Set(newX, newY, newZ) end

--- ##### Static Method
--- ***
--- Returns the angle in degrees between `from` and `to`.
--- @param from Vector3 The vector from which the angular difference is measured.
--- @param to Vector3 The vector to which the angular difference is measured.
--- @return number # the angle in degrees between from and to.
function Vector3:Angle(from, to) end

--- ##### Static Method
--- ***
--- Returns a copy of vector with its magnitude clamped to maxLength.
--- @param vector Vector3 
--- @param maxLength number max Length
--- @return Vector3 # a copy of vector with its magnitude clamped to maxLength.
function Vector3:ClampMagnitude(vector, maxLength) end

--- ##### Static Method
--- ***
--- Cross Product of two vectors.
--- @param lhs Vector3 Left hand side Vector3
--- @param rhs Vector3 Right Hand Side Vector3
--- @return Vector3 # Cross Product of two vectors.
function Vector3:Cross(lhs, rhs) end

--- ##### Static Method
--- ***
--- Returns the distance between a and b.
--- @param a Vector3 
--- @param b Vector3 
--- @return number # distance between a and b.
function Vector3:Distance(a, b) end

--- ##### Static Method
--- ***
--- Dot Product of two vectors.
--- @param lhs Vector3 
--- @param rhs Vector3 
--- @return number # Dot Product of two vectors.
function Vector3:Dot(lhs, rhs) end

--- ##### Static Method
--- ***
--- Linearly interpolates between two points.
--- @param a Vector3 
--- @param b Vector3 
--- @param t number 
--- @return Vector3 # Linearly interpolated Vector3.
function Vector3:Lerp(a, b, t) end

--- ##### Static Method
--- ***
--- Linearly interpolates between two vectors.
--- @param a Vector3 
--- @param b Vector3 
--- @param t number 
--- @return Vector3 # Linearly interpolated Vector3.
function Vector3:LerpUnclamped(a, b, t) end

--- ##### Static Method
--- ***
--- Returns a vector that is made from the largest components of two vectors.
--- @param lhs Vector3 
--- @param rhs Vector3 
--- @return Vector3 # vector that is made from the largest components of two vectors.
function Vector3:Max(lhs, rhs) end

--- ##### Static Method
--- ***
--- Returns a vector that is made from the smallest components of two vectors.
--- @param lhs Vector3 
--- @param rhs Vector3 
--- @return Vector3 # vector that is made from the smallest components of two vectors.
function Vector3:Min(lhs, rhs) end

--- ##### Static Method
--- ***
--- Calculate a position between the points specified by current and target, moving no farther than the distance specified by maxDistanceDelta.
--- @param current Vector3 The position to move from.
--- @param target Vector3 The position to move towards.
--- @param maxDistanceDelta number Distance to move current per call.
--- @return Vector3 # The new position.
function Vector3:MoveTowards(current, target, maxDistanceDelta) end

--- ##### Static Method
--- ***
--- Makes this vector have a magnitude of 1.
--- @param value Vector3 
--- @return Vector3 # normalized vector
function Vector3:Normalize(value) end

--- ##### Static Method
--- ***
--- Projects a vector onto another vector.
--- @param vector Vector3 
--- @param onNormal Vector3 
--- @return Vector3 # Projected Vector
function Vector3:Project(vector, onNormal) end

--- ##### Static Method
--- ***
--- Reflects a vector off the plane defined by a normal.
--- @param inDirection Vector3 the inDirection vector is treated as a directional arrow coming in to the plane
--- @param inNormal Vector3 The inNormal vector defines a plane
--- @return Vector3 # Reflected vector
function Vector3:Reflect(inDirection, inNormal) end

--- ##### Static Method
--- ***
--- Rotates a vector current towards target.
--- @param current Vector3 The vector being managed.
--- @param target Vector3 The vector.
--- @param maxRadiansDelta number The maximum angle in radians allowed for this rotation.
--- @param maxMagnitudeDelta number The maximum allowed change in vector magnitude for this rotation.
--- @return Vector3 # The location that RotateTowards generates.
function Vector3:RotateTowards(current, target, maxRadiansDelta, maxMagnitudeDelta) end

--- ##### Static Method
--- ***
--- Multiplies two vectors component-wise.
--- @param a Vector3 
--- @param b Vector3 
--- @return Vector3 # result
function Vector3:Scale(a, b) end

--- ##### Static Method
--- ***
--- Returns the signed angle in degrees between from and to.
--- @param from Vector3 The vector from which the angular difference is measured.
--- @param to Vector3 The vector to which the angular difference is measured.
--- @param axis Vector3 A vector around which the other vectors are rotated.
--- @return number # the signed angle in degrees between from and to.
function Vector3:SignedAngle(from, to, axis) end

--- ##### Static Method
--- ***
--- Spherically interpolates between two vectors.
--- @param a Vector3 
--- @param b Vector3 
--- @param t number is clamped to the range [0, 1].
--- @return Vector3 # Spherically interpolated Vector3
function Vector3:Slerp(a, b, t) end

--- ##### Static Method
--- ***
--- Spherically interpolates between two vectors.
--- @param a Vector3 
--- @param b Vector3 
--- @param t number 
--- @return Vector3 # Spherically interpolated Vector
function Vector3:SlerpUnclamped(a, b, t) end

--- ##### Type *Vector4*
--- ***
--- Representation of four-dimensional vectors.<br> Check out [Unity Vector4](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/Vector4.html).
--- @class Vector4
--- @field magnitude number **Read-Only**  |  Returns the length of this vector (Read Only).
--- @field negativeInfinity Vector4 **Static**  **Read-Only**  |  Shorthand for writing `Vector4(-1.#INF,-1.#INF,-1.#INF,-1.#INF)`.
--- @field normalized Vector4 **Read-Only**  |  Returns this vector with a magnitude of 1 (Read Only).
--- @field one Vector4 **Static**  **Read-Only**  |  Shorthand for writing `Vector4(1,1,1,1)`.
--- @field positiveInfinity Vector4 **Static**  **Read-Only**  |  Shorthand for writing `Vector4(#INF,#INF,#INF,#INF)`.
--- @field sqrMagnitude number **Read-Only**  |  Returns the squared length of this vector (Read Only).
--- @field w number W component of the vector.
--- @field x number X component of the vector.
--- @field y number Y component of the vector.
--- @field z number Z component of the vector.
--- @field zero Vector4 **Static**  **Read-Only**  |  Shorthand for writing `Vector4(0,0,0,0)`.
--- @operator sub(Vector4) : Vector4 # Subtracts one vector from another.
--- @operator unm : Vector4 # Negates a vector. Each component in the result is negated.
--- @operator mul(number) : Vector4 # Multiplies a vector by a number.
--- @operator div(number) : Vector4 # Divides a vector by a number.
--- @operator add(Vector4) : Vector4 # Adds two vectors. Adds corresponding components together.
Vector4 = {}

--- ##### Constructor for *Vector4*
--- ***
--- Creates a new vector with given x, y, z, w components.
--- @param x number x
--- @param y number y
--- @param z number z
--- @param w number w
--- @return Vector4
function Vector4(x, y, z, w) end

--- ##### Method
--- ***
--- Makes this vector have a magnitude of 1.
function Vector4.Normalize() end

--- ##### Method
--- ***
--- Set x, y, z and w components of an existing Vector4.
--- @param newX number newX
--- @param newY number newY
--- @param newZ number newZ
--- @param newW number newW
function Vector4.Set(newX, newY, newZ, newW) end

--- ##### Static Method
--- ***
--- Returns the distance between a and b.
--- @param a Vector4 a
--- @param b Vector4 b
--- @return number # distance between a and b.
function Vector4:Distance(a, b) end

--- ##### Static Method
--- ***
--- Dot Product of two vectors.
--- @param a Vector4 a
--- @param b Vector4 b
--- @return number # Dot Product of two vectors.
function Vector4:Dot(a, b) end

--- ##### Static Method
--- ***
--- Linearly interpolates between two vectors.
--- @param a Vector4 a
--- @param b Vector4 b
--- @param t number t
--- @return Vector4 # Interpolates between a and b by amount t.
function Vector4:Lerp(a, b, t) end

--- ##### Static Method
--- ***
--- Linearly interpolates between two vectors.
--- @param a Vector4 a
--- @param b Vector4 b
--- @param t number t
--- @return Vector4 # Interpolates between a and b by amount t.
function Vector4:LerpUnclamped(a, b, t) end

--- ##### Static Method
--- ***
--- Returns a vector that is made from the largest components of two vectors.
--- @param lhs Vector4 lhs Vector4
--- @param rhs Vector4 rhs Vector4.
--- @return Vector4 # Vector that is made from the largest components of two vectors.
function Vector4:Max(lhs, rhs) end

--- ##### Static Method
--- ***
--- Returns a vector that is made from the smallest components of two vectors.
--- @param  lhs Vector4  lhs Vector 4.
--- @param rhs Vector4 rhs Vector4.
--- @return Vector4 # Vector that is made from the smallest components of two vectors.
function Vector4:Min( lhs, rhs) end

--- ##### Static Method
--- ***
--- Moves a point `current` towards `target`.
--- @param current Vector4 current
--- @param target Vector4 target
--- @param maxDistanceDelta number Max Distance Delta
function Vector4:MoveTowards(current, target, maxDistanceDelta) end

--- ##### Static Method
--- ***
--- Projects a vector onto another vector.
--- @param a Vector4 a
--- @param b Vector4 b
--- @return Vector4 # Returns a projected onto b.
function Vector4:Project(a, b) end

--- ##### Static Method
--- ***
--- Multiplies two vectors component-wise.
--- @param a Vector4 a
--- @param b Vector4 b
--- @return Vector4 # Scaled Vector 
function Vector4:Scale(a, b) end

--- ##### Type *VideoClip* inherits *Object*
--- ***
--- A container for video data.
--- @class VideoClip
--- @field audioTrackCount number Number of audio tracks in the clip.
--- @field frameCount number The length of the VideoClip in frames. (Read Only).
--- @field frameRate number The frame rate of the clip in frames/second. (Read Only).
--- @field height number The height of the images in the video clip in pixels. (Read Only).
--- @field length number The length of the video clip in seconds. (Read Only).
--- @field originalPath string The video clip path in the project's assets. (Read Only).
--- @field pixelAspectRatioDenominator number Denominator of the pixel aspect ratio (num:den). (Read Only).
--- @field sRGB boolean Whether the imported clip contains sRGB color data (Read Only).
--- @field width number The width of the images in the video clip in pixels. (Read Only).
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
VideoClip = {}

--- ##### Method
--- ***
--- The number of channels in the audio track. E.g. 2 for a stereo track.
--- @param audioTrackIdx number Index of the audio queried audio track.
--- @return number # The number of channels.
function VideoClip.GetAudioChannelCount(audioTrackIdx) end

--- ##### Method
--- ***
--- Get the audio track language. Can be unknown.
--- @param audioTrackIdx number Index of the audio queried audio track.
--- @return string # The abbreviated name of the language.
function VideoClip.GetAudioLanguage(audioTrackIdx) end

--- ##### Method
--- ***
--- Get the audio track sampling rate in Hertz.
--- @param audioTrackIdx number Index of the audio queried audio track.
--- @return number # The sampling rate in Hertz.
function VideoClip.GetAudioSampleRate(audioTrackIdx) end

--- ##### Method Inherited from *Object*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function VideoClip.GetInstanceID() end

--- ##### Type *VideoPlayer* inherits *Behaviour*
--- ***
--- Plays video content onto a target.
--- @class VideoPlayer
--- @field aspectRatio VideoAspectRatio Defines how the video content will be stretched to fill the target area.
--- @field audioOutputMode VideoAudioOutputMode Destination for the audio embedded in the video.
--- @field audioTrackCount number Number of audio tracks found in the data source currently configured. (Read Only)
--- @field canSetDirectAudioVolume boolean **Read-Only**  |  Whether direct-output volume controls are supported for the current platform and video format. (Read Only)
--- @field canSetPlaybackSpeed boolean **Read-Only**  |  Whether the playback speed can be changed. (Read Only)
--- @field canSetSkipOnDrop boolean **Read-Only**  |  Whether frame-skipping to maintain synchronization can be controlled. (Read Only)
--- @field canSetTime boolean **Read-Only**  |  Whether current time can be changed using the time or timeFrames property. (Read Only)
--- @field canSetTimeSource boolean **Read-Only**  |  Whether the time source followed by the VideoPlayer can be changed. (Read Only)
--- @field canStep boolean **Read-Only**  |  Returns true if the VideoPlayer can step forward through the video content. (Read Only)
--- @field clip VideoClip The clip being played by the VideoPlayer.
--- @field clockResyncOccurred VideoPlayerclockResyncOccurredEventHandler **Event**  | Invoked when the VideoPlayer clock is synced back to its VideoTimeReference.
--- @field clockTime number The clock time that the VideoPlayer follows to schedule its samples. The clock time is expressed in seconds. (Read Only)
--- @field controlledAudioTrackCount number Number of audio tracks that this VideoPlayer will take control of.
--- @field controlledAudioTrackMaxCount number **Static**  |  Maximum number of audio tracks that can be controlled. (Read Only)
--- @field errorReceived VideoPlayererrorReceivedEventHandler **Event**  | Errors such as HTTP connection problems are reported through this callback.
--- @field externalReferenceTime number Reference time of the external clock the VideoPlayer uses to correct its drift.
--- @field frameCount number Number of frames in the current video content. (Read Only)
--- @field frameRate number The frame rate of the clip or URL in frames/second. (Read Only)
--- @field frameReady VideoPlayerframeReadyEventHandler **Event**  | Invoked when a new frame is ready.
--- @field height number The height of the images in the VideoClip, or URL, in pixels. (Read Only)
--- @field isLooping boolean **Read-Only**  |  Determines whether the VideoPlayer restarts from the beginning when it reaches the end of the clip.
--- @field isPaused boolean **Read-Only**  |  Whether playback is paused. (Read Only)
--- @field isPlaying boolean **Read-Only**  |  Whether content is being played. (Read Only)
--- @field isPrepared boolean **Read-Only**  |  Whether the VideoPlayer has successfully prepared the content to be played. (Read Only)
--- @field length number **Read-Only**  |  The length of the VideoClip, or the URL, in seconds. (Read Only)
--- @field loopPointReached VideoPlayerloopPointReachedEventHandler **Event**  | Invoked when the VideoPlayer reaches the end of the content to play.
--- @field pixelAspectRatioDenominator number **Read-Only**  |  Denominator of the pixel aspect ratio (num:den) for the VideoClip or the URL. (Read Only)
--- @field pixelAspectRatioNumerator number **Read-Only**  |  Numerator of the pixel aspect ratio (num:den) for the VideoClip or the URL. (Read Only)
--- @field playbackSpeed number Factor by which the basic playback rate will be multiplied.
--- @field playOnAwake boolean Whether the content will start playing back as soon as the component awakes.
--- @field prepareCompleted VideoPlayerprepareCompletedEventHandler **Event**  | Invoked when the VideoPlayer preparation is complete.
--- @field renderMode VideoRenderMode Where the video content will be drawn.
--- @field seekCompleted VideoPlayerseekCompletedEventHandler **Event**  | Invoke after a seek operation completes.
--- @field sendFrameReadyEvents boolean Enables the frameReady events.
--- @field skipOnDrop boolean Whether the VideoPlayer is allowed to skip frames to catch up with current time.
--- @field source VideoSource The source that the VideoPlayer uses for playback.
--- @field started VideoPlayerstartedEventHandler **Event**  | Invoked immediately after Play is called.
--- @field targetMaterialProperty string Material texture property which is targeted when VideoPlayer.renderMode is set to Video.VideoTarget.MaterialOverride.
--- @field targetMaterialRenderer Renderer Renderer which is targeted when VideoPlayer.renderMode is set to Video.VideoTarget.MaterialOverride
--- @field texture Texture Internal texture in which video content is placed. (Read Only)
--- @field time number The presentation time of the currently available frame in VideoPlayer.texture.
--- @field timeReference VideoTimeReference The clock that the VideoPlayer observes to detect and correct drift.
--- @field timeSource VideoTimeSource The source used used by the VideoPlayer to derive its current time.
--- @field url string The file or HTTP URL that the VideoPlayer reads content from.
--- @field waitForFirstFrame boolean Determines whether the VideoPlayer will wait for the first frame to be loaded into the texture before starting playback when VideoPlayer.playOnAwake is on.
--- @field width number The width of the images in the VideoClip, or URL, in pixels. (Read Only)
--- @field enabled boolean **Inherited**  |  Enabled Behaviours are Updated, disabled Behaviours are not.
--- @field isActiveAndEnabled boolean **Inherited**  |  Has the Behaviour had active and enabled called?
--- @field gameObject GameObject **Read-Only**  **Inherited**  |  The game object this component is attached to. A component is always attached to a game object.
--- @field tag string **Read-Only**  **Inherited**  |  The tag of this game object.
--- @field transform Transform **Read-Only**  **Inherited**  |  The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
VideoPlayer = {}

--- ##### Method
--- ***
--- Enable/disable audio track decoding. Only effective when the VideoPlayer is not currently playing.
--- @param trackIndex number Index of the audio track to enable/disable.
--- @param enabled boolean True for enabling the track. False for disabling the track.
function VideoPlayer.EnableAudioTrack(trackIndex, enabled) end

--- ##### Method
--- ***
--- The number of audio channels in the specified audio track.
--- @param trackIndex number Index for the audio track being queried.
--- @return number # Number of audio channels.
function VideoPlayer.GetAudioChannelCount(trackIndex) end

--- ##### Method
--- ***
--- Returns the language code, if any, for the specified track.
--- @param trackIndex number Index of the audio track to query.
--- @return string # Language code.
function VideoPlayer.GetAudioLanguageCode(trackIndex) end

--- ##### Method
--- ***
--- Gets the audio track sampling rate in Hertz.
--- @param trackIndex number Index of the audio track to query.
--- @return number # The sampling rate in Hertz.
function VideoPlayer.GetAudioSampleRate(trackIndex) end

--- ##### Method
--- ***
--- Gets the direct-output audio mute status for the specified track.
--- @param trackIndex number trackIndex
--- @return boolean # direct-output audio mute status for the specified track.
function VideoPlayer.GetDirectAudioMute(trackIndex) end

--- ##### Method
--- ***
--- Return the direct-output volume for specified track.
--- @param trackIndex number Track index for which the volume is queried.
--- @return number # Volume, between 0 and 1.
function VideoPlayer.GetDirectAudioVolume(trackIndex) end

--- ##### Method
--- ***
--- Gets the AudioSource that will receive audio samples for the specified track if VideoPlayer.audioOutputMode is set to VideoAudioOutputMode.AudioSource.
--- @param trackIndex number Index of the audio track for which the AudioSource is wanted.
--- @return AudioSource # The source associated with the audio track.
function VideoPlayer.GetTargetAudioSource(trackIndex) end

--- ##### Method
--- ***
--- Whether decoding for the specified audio track is enabled. See VideoPlayer.EnableAudioTrack for distinction with mute.
--- @param trackIndex number Index of the audio track being queried.
--- @return boolean # Returns true if decoding for the specified audio track is enabled.
function VideoPlayer.IsAudioTrackEnabled(trackIndex) end

--- ##### Method
--- ***
--- Pauses the playback and leaves the current time intact.
function VideoPlayer.Pause() end

--- ##### Method
--- ***
--- Starts playback.
function VideoPlayer.Play() end

--- ##### Method
--- ***
--- Initiates playback engine preparation.
function VideoPlayer.Prepare() end

--- ##### Method
--- ***
--- Set the direct-output audio mute status for the specified track.
--- @param trackIndex number Track index for which the mute is set.
--- @param mute boolean Mute on/off.
function VideoPlayer.SetDirectAudioMute(trackIndex, mute) end

--- ##### Method
--- ***
--- Set the direct-output audio volume for the specified track.
--- @param trackIndex number Track index for which the volume is set.
--- @param volume number New volume, between 0 and 1.
function VideoPlayer.SetDirectAudioVolume(trackIndex, volume) end

--- ##### Method
--- ***
--- Sets the AudioSource that will receive audio samples for the specified track if this audio target is selected with VideoPlayer.audioOutputMode. 
--- @param trackIndex number Index of the audio track to associate with the specified AudioSource.
--- @param source AudioSource AudioSource to associate with the audio track.
function VideoPlayer.SetTargetAudioSource(trackIndex, source) end

--- ##### Method
--- ***
--- Advances the current time by one frame immediately.
function VideoPlayer.StepForward() end

--- ##### Method
--- ***
--- Stops the playback and sets the current time to 0.
function VideoPlayer.Stop() end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Calls the method named methodName on every Lua Script in this game object or any of its children.
--- @param methodName string Name of the method to call.
--- @param parameter any? **Optional**(default = nil) Optional parameter to pass to the method (can be any value).
function VideoPlayer.BroadcastMessage(methodName, parameter) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function VideoPlayer.CompareTag(tag) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # Array of all Lua scripts that attached to the game object.
function VideoPlayer.GetAllLuaScripts() end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the component of Type type if the game object has one attached, nil if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # the component of Type type
function VideoPlayer.GetComponent(type) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function VideoPlayer.GetComponentInChildren(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function VideoPlayer.GetComponentInParent(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function VideoPlayer.GetComponents(type) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function VideoPlayer.GetComponentsInChildren(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function VideoPlayer.GetComponentsInParent(t) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Calls the method named methodName on every Lua Script in this game object. 
--- @param methodName string Name of the method to call.
--- @param value any? **Optional**(default = nil) Optional parameter for the method.
function VideoPlayer.SendMessage(methodName, value) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Calls the method named methodName on every LuaScript in this game object and on every ancestor of the behaviour.
--- @param methodName string Name of method to call.
--- @param value any? **Optional**(default = nil) Optional parameter value for the method.
function VideoPlayer.SendMessageUpwards(methodName, value) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of the component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or nil.
function VideoPlayer.TryGetComponent(type) end

--- ##### Method Inherited from *Behaviour*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function VideoPlayer.GetInstanceID() end

--- ##### Type
--- ***
--- Event Handler
--- @class VideoPlayerclockResyncOccurredEventHandler : EventHandler
VideoPlayerclockResyncOccurredEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun(source : VideoPlayer, seconds : number)  Function to registered
function VideoPlayerclockResyncOccurredEventHandler.Add(handler)end

--- ##### Type
--- ***
--- Event Handler
--- @class VideoPlayererrorReceivedEventHandler : EventHandler
VideoPlayererrorReceivedEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun(source : VideoPlayer, message : string)  Function to registered
function VideoPlayererrorReceivedEventHandler.Add(handler)end

--- ##### Type
--- ***
--- Event Handler
--- @class VideoPlayerframeReadyEventHandler : EventHandler
VideoPlayerframeReadyEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun(source : VideoPlayer, frameIdx : number)  Function to registered
function VideoPlayerframeReadyEventHandler.Add(handler)end

--- ##### Type
--- ***
--- Event Handler
--- @class VideoPlayerloopPointReachedEventHandler : EventHandler
VideoPlayerloopPointReachedEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun(source : VideoPlayer)  Function to registered
function VideoPlayerloopPointReachedEventHandler.Add(handler)end

--- ##### Type
--- ***
--- Event Handler
--- @class VideoPlayerprepareCompletedEventHandler : EventHandler
VideoPlayerprepareCompletedEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun(source : VideoPlayer)  Function to registered
function VideoPlayerprepareCompletedEventHandler.Add(handler)end

--- ##### Type
--- ***
--- Event Handler
--- @class VideoPlayerseekCompletedEventHandler : EventHandler
VideoPlayerseekCompletedEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun(source : VideoPlayer)  Function to registered
function VideoPlayerseekCompletedEventHandler.Add(handler)end

--- ##### Type
--- ***
--- Event Handler
--- @class VideoPlayerstartedEventHandler : EventHandler
VideoPlayerstartedEventHandler={};

--- ##### Method
--- ***
--- Registers the provided function as handler function
--- @param handler fun(source : VideoPlayer)  Function to registered
function VideoPlayerstartedEventHandler.Add(handler)end

--- ##### Type *WheelCollider* inherits *Component*
--- ***
--- A special collider for vehicle wheels. [Unity WheelCollider](https://docs.unity3d.com/ScriptReference/WheelCollider.html)
--- @class WheelCollider
--- @field brakeTorque number Brake torque expressed in Newton metres. Must be positive.
--- @field center Vector3 The center of the wheel, measured in the object's local space.
--- @field forceAppPointDistance number Application point of the suspension and tire forces measured from the base of the resting wheel.
--- @field forwardFriction WheelFrictionCurve Properties of tire friction in the direction the wheel is pointing in.
--- @field isGrounded boolean **Read-Only**  |  Indicates whether the wheel currently collides with something (Read Only).
--- @field mass number The mass of the wheel, expressed in kilograms. Must be larger than zero. Typical values would be in range (20,80).
--- @field motorTorque number Motor torque on the wheel axle expressed in Newton metres. Positive or negative depending on direction.
--- @field radius number The radius of the wheel, measured in local space.
--- @field rpm number **Read-Only**  |  Current wheel axle rotation speed, in rotations per minute (Read Only).
--- @field sidewaysFriction WheelFrictionCurve Properties of tire friction in the sideways direction.
--- @field sprungMass number The mass supported by this WheelCollider.
--- @field steerAngle number Steering angle in degrees, always around the local y-axis.
--- @field suspensionDistance number Maximum extension distance of wheel suspension, measured in local space.
--- @field suspensionExpansionLimited boolean Limits the expansion velocity of the Wheel Collider's suspension. If you set this property on a Rigidbody that has several Wheel Colliders, such as a vehicle, then it affects all other Wheel Colliders on the Rigidbody.
--- @field suspensionSpring JointSpring The parameters of wheel's suspension. The suspension attempts to reach a target position by applying a linear force and a damping force.
--- @field wheelDampingRate number The damping rate of the wheel. Must be larger than zero.
--- @field gameObject GameObject **Read-Only**  **Inherited**  |  The game object this component is attached to. A component is always attached to a game object.
--- @field tag string **Read-Only**  **Inherited**  |  The tag of this game object.
--- @field transform Transform **Read-Only**  **Inherited**  |  The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
WheelCollider = {}

--- ##### Method
--- ***
--- Configure vehicle sub-stepping parameters.
--- @param speedThreshold number The speed threshold of the sub-stepping algorithm.
--- @param stepsBelowThreshold string Amount of simulation sub-steps when vehicle's speed is below speedThreshold.
--- @param stepsAboveThreshold number Amount of simulation sub-steps when vehicle's speed is above speedThreshold.
function WheelCollider.ConfigureVehicleSubsteps(speedThreshold, stepsBelowThreshold, stepsAboveThreshold) end

--- ##### Method
--- ***
--- Gets ground collision data for the wheel.
--- @return boolean # True if the wheel collides with something
--- @return WheelHit # the hit structure if the wheel collides with something, Nil otherwise.
function WheelCollider.GetGroundHit() end

--- ##### Method
--- ***
--- Gets the world space pose of the wheel accounting for ground contact, suspension limits, steer angle, and rotation angle.
--- @return Vector3 # Position of the wheel in world space.
--- @return Quaternion # Rotation of the wheel in world space.
function WheelCollider.GetWorldPose() end

--- ##### Method
--- ***
--- Reset the sprung masses of the vehicle.
function WheelCollider.ResetSprungMasses() end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object or any of its children.
--- @param methodName string Name of the method to call.
--- @param parameter any? **Optional**(default = nil) Optional parameter to pass to the method (can be any value).
function WheelCollider.BroadcastMessage(methodName, parameter) end

--- ##### Method Inherited from *Component*
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function WheelCollider.CompareTag(tag) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # Array of all Lua scripts that attached to the game object.
function WheelCollider.GetAllLuaScripts() end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type if the game object has one attached, nil if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # the component of Type type
function WheelCollider.GetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function WheelCollider.GetComponentInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function WheelCollider.GetComponentInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function WheelCollider.GetComponents(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function WheelCollider.GetComponentsInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function WheelCollider.GetComponentsInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object. 
--- @param methodName string Name of the method to call.
--- @param value any? **Optional**(default = nil) Optional parameter for the method.
function WheelCollider.SendMessage(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every LuaScript in this game object and on every ancestor of the behaviour.
--- @param methodName string Name of method to call.
--- @param value any? **Optional**(default = nil) Optional parameter value for the method.
function WheelCollider.SendMessageUpwards(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of the component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or nil.
function WheelCollider.TryGetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function WheelCollider.GetInstanceID() end

--- ##### Type *WheelFrictionCurve*
--- ***
--- WheelFrictionCurve is used by the WheelCollider to describe friction properties of the wheel tire.
--- @class WheelFrictionCurve
--- @field asymptoteSlip number Asymptote point slip (default 2).
--- @field asymptoteValue number Force at the asymptote slip (default 10000).
--- @field extremumSlip number Extremum point slip (default 1).
--- @field extremumValue number Force at the extremum slip (default 20000).
--- @field stiffness number Multiplier for the extremumValue and asymptoteValue values (default 1).
WheelFrictionCurve = {}

--- ##### Type *WheelHit*
--- ***
--- Contact information for the wheel, reported by WheelCollider.
--- @class WheelHit
--- @field collider Collider The other Collider the wheel is hitting.
--- @field force number The magnitude of the force being applied for the contact.
--- @field forwardDir Vector3 The direction the wheel is pointing in.
--- @field forwardSlip number Tire slip in the rolling direction. Acceleration slip is negative, braking slip is positive.
--- @field normal Vector3 The normal at the point of contact.
--- @field point Vector3 The point of contact between the wheel and the ground.
--- @field sidewaysDir Vector3 The sideways direction of the wheel.
--- @field sidewaysSlip number Tire slip in the sideways direction.
WheelHit = {}

--- ##### Constructor for *WheelHit*
--- ***
--- Create new WheelHit
--- @return WheelHit
function WheelHit() end

--- ##### Type *WindZone* inherits *Component*
--- ***
--- Wind Zones add realism to the trees you create by making them wave their branches and leaves as if blown by the wind.
--- @class WindZone
--- @field mode WindZoneMode Defines the type of wind zone to be used (Spherical or Directional).
--- @field radius number Radius of the Spherical Wind Zone (only active if the WindZoneMode is set to Spherical).
--- @field windMain number The primary wind force. It produces a softly changing wind Pressure.
--- @field windPulseFrequency number Defines the frequency of the wind changes.
--- @field windPulseMagnitude number Defines how much the wind changes over time.
--- @field windTurbulence number The turbulence wind force. Produces a rapidly changing wind pressure.
--- @field gameObject GameObject **Read-Only**  **Inherited**  |  The game object this component is attached to. A component is always attached to a game object.
--- @field tag string **Read-Only**  **Inherited**  |  The tag of this game object.
--- @field transform Transform **Read-Only**  **Inherited**  |  The Transform attached to this GameObject.
--- @field hideFlags HideFlags **Inherited**  |  Should the object be hidden, saved with the Scene or modifiable by the user?
--- @field name string **Inherited**  |  The name of the object.
WindZone = {}

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object or any of its children.
--- @param methodName string Name of the method to call.
--- @param parameter any? **Optional**(default = nil) Optional parameter to pass to the method (can be any value).
function WindZone.BroadcastMessage(methodName, parameter) end

--- ##### Method Inherited from *Component*
--- ***
--- Is this game object tagged with tag ?
--- @param tag string The tag to compare.
--- @return boolean # Is this game object tagged with tag ?
function WindZone.CompareTag(tag) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns an array of all Lua scripts that attached to the game object.
--- @return LuaBehaviour[] # Array of all Lua scripts that attached to the game object.
function WindZone.GetAllLuaScripts() end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type if the game object has one attached, nil if it doesn't.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent # the component of Type type
function WindZone.GetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its children using depth first search.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function WindZone.GetComponentInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the component of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent # A component of the matching type, if found.
function WindZone.GetComponentInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject.
--- @generic TComponent
--- @param type TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject.
function WindZone.GetComponents(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its children.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its children.
function WindZone.GetComponentsInChildren(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns all components of Type type in the GameObject or any of its parents.
--- @generic TComponent
--- @param t TComponent The type of Component to retrieve.
--- @return TComponent[] # all components of Type type in the GameObject or any of its parents.
function WindZone.GetComponentsInParent(t) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every Lua Script in this game object. 
--- @param methodName string Name of the method to call.
--- @param value any? **Optional**(default = nil) Optional parameter for the method.
function WindZone.SendMessage(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Calls the method named methodName on every LuaScript in this game object and on every ancestor of the behaviour.
--- @param methodName string Name of method to call.
--- @param value any? **Optional**(default = nil) Optional parameter value for the method.
function WindZone.SendMessageUpwards(methodName, value) end

--- ##### Method Inherited from *Component*
--- ***
--- Gets the component of the specified type, if it exists.
--- @generic TComponent
--- @param type TComponent The type of the component to retrieve.
--- @return boolean # Returns true if the component is found, false otherwise.
--- @return TComponent # The output argument that will contain the component or nil.
function WindZone.TryGetComponent(type) end

--- ##### Method Inherited from *Component*
--- ***
--- Returns the instance id of the object.
--- @return number # instance id of the object.
function WindZone.GetInstanceID() end

--- @enum Space
--- ##### Enum *Space*
--- ***
--- The coordinate space in which to operate. [Unity Space](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/Space.html).
Space = {
	--- Applies transformation relative to the local coordinate system.
	Self = 0,
	--- Applies transformation relative to the world coordinate system.
	World = 1
}

--- @enum SendMessageOptions
--- ##### Enum *SendMessageOptions*
--- ***
--- Options for how to send a message. This is used by SendMessage & BroadcastMessage in GameObject & Component. [Unity SendMessageOptions](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/SendMessageOptions.html)
SendMessageOptions = {
	--- No receiver is required for SendMessage.
	DontRequireReceiver = 0,
	--- A receiver is required for SendMessage.
	RequireReceiver = 1
}

--- @enum HideFlags
--- ##### Enum *HideFlags*
--- ***
--- Bit mask that controls object destruction, saving and visibility in inspectors. [Unity HideFlags](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/HideFlags.html)
HideFlags = {
	--- The object will not be saved to the Scene. It will not be destroyed when a new Scene is loaded. It is a shortcut for HideFlags.DontSaveInBuild | HideFlags.DontSaveInEditor | HideFlags.DontUnloadUnusedAsset.
	DontSave = 0,
	--- The object will not be saved when building a player.
	DontSaveInBuild = 1,
	--- The object will not be saved to the Scene in the editor.
	DontSaveInEditor = 2,
	--- The object will not be unloaded by Resources.UnloadUnusedAssets.
	DontUnloadUnusedAsset = 3,
	--- The GameObject is not shown in the Hierarchy, not saved to to Scenes, and not unloaded by Resources.UnloadUnusedAssets.
	HideAndDontSave = 4,
	--- The object will not appear in the hierarchy.
	HideInHierarchy = 5,
	--- It is not possible to view it in the inspector.
	HideInInspector = 6,
	--- A normal, visible object. This is the default.
	None = 7,
	--- The object is not be editable in the inspector.
	NotEditable = 8
}

--- @enum PrimitiveType
--- ##### Enum *PrimitiveType*
--- ***
--- The various primitives that can be created using the GameObject.CreatePrimitive function. [Unity PrimitiveType](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/PrimitiveType.html)
PrimitiveType = {
	--- A capsule primitive.
	Capsule = 0,
	--- A cube primitive.
	Cube = 1,
	--- A cylinder primitive.
	Cylinder = 2,
	--- A plane primitive.
	Plane = 3,
	--- A quad primitive.
	Quad = 4,
	--- A sphere primitive.
	Sphere = 5
}

--- @enum PhysicMaterialCombine
--- ##### Enum *PhysicMaterialCombine*
--- ***
--- Describes how physics materials of the colliding objects are combined. [Unity PhysicMaterialCombine](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/PhysicMaterialCombine.html)
PhysicMaterialCombine = {
	--- Averages the friction/bounce of the two colliding materials.
	Average = 0,
	--- Uses the larger friction/bounce of the two colliding materials.
	Maximum = 1,
	--- Uses the smaller friction/bounce of the two colliding materials.
	Minimum = 2,
	--- Multiplies the friction/bounce of the two colliding materials.
	Multiply = 3
}

--- @enum CollisionDetectionMode
--- ##### Enum *CollisionDetectionMode*
--- ***
--- The collision detection mode constants used for Rigidbody.collisionDetectionMode. [Unity CollisionDetectionMode](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/CollisionDetectionMode.html)
CollisionDetectionMode = {
	--- Continuous collision detection is on for colliding with static mesh geometry.
	Continuous = 0,
	--- Continuous collision detection is on for colliding with static and dynamic geometry.
	ContinuousDynamic = 1,
	--- Speculative continuous collision detection is on for static and dynamic geometries
	ContinuousSpeculative = 2,
	--- Continuous collision detection is off for this Rigidbody.
	Discrete = 3
}

--- @enum RigidbodyConstraints
--- ##### Enum *RigidbodyConstraints*
--- ***
--- Use these flags to constrain motion of Rigidbodies. [Unity RigidbodyConstraints](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/RigidbodyConstraints.html)
RigidbodyConstraints = {
	--- Freeze rotation and motion along all axes.
	FreezeAll = 0,
	--- Freeze motion along all axes.
	FreezePosition = 1,
	--- Freeze motion along the X-axis.
	FreezePositionX = 2,
	--- Freeze motion along the Y-axis.
	FreezePositionY = 3,
	--- Freeze motion along the Z-axis.
	FreezePositionZ = 4,
	--- Freeze rotation along all axes.
	FreezeRotation = 5,
	--- Freeze rotation along the X-axis.
	FreezeRotationX = 6,
	--- Freeze rotation along the Y-axis.
	FreezeRotationY = 7,
	--- Freeze rotation along the Z-axis.
	FreezeRotationZ = 8,
	--- No constraints.
	None = 9
}

--- @enum RigidbodyInterpolation
--- ##### Enum *RigidbodyInterpolation*
--- ***
--- Rigidbody interpolation mode. [Unity RigidbodyInterpolation](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/RigidbodyInterpolation.html)
RigidbodyInterpolation = {
	--- Extrapolation will predict the position of the rigidbody based on the current velocity.
	Extrapolate = 0,
	--- Interpolation will always lag a little bit behind but can be smoother than extrapolation.
	Interpolate = 1,
	--- No Interpolation.
	None = 2
}

--- @enum ForceMode
--- ##### Enum *ForceMode*
--- ***
--- Use ForceMode to specify how to apply a force using Rigidbody.AddForce. The AddForce function impacts how your GameObject moves by allowing you to define your own force vector, as well as choosing how to apply this force to the GameObject (this GameObject must have a Rigidbody component attached). ForceMode allows you to choose from four different ways to affect the GameObject using this Force: Acceleration, Force, Impulse, and VelocityChange. [Unity ForceMode](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/ForceMode.html)
ForceMode = {
	--- Add a continuous acceleration to the rigidbody, ignoring its mass.
	Acceleration = 0,
	--- Add a continuous force to the rigidbody, using its mass.
	Force = 1,
	--- Add an instant force impulse to the rigidbody, using its mass.
	Impulse = 2,
	--- Add an instant velocity change to the rigidbody, ignoring its mass.
	VelocityChange = 3
}

--- @enum QueryTriggerInteraction
--- ##### Enum *QueryTriggerInteraction*
--- ***
--- Overrides the global Physics.queriesHitTriggers. [Unity QueryTriggerInteraction](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/QueryTriggerInteraction.html)
QueryTriggerInteraction = {
	--- Queries always report Trigger hits.
	Collide = 0,
	--- Queries never report Trigger hits.
	Ignore = 1,
	--- Queries use the global Physics.queriesHitTriggers setting.
	UseGlobal = 2
}

--- @enum FFTWindow
--- ##### Enum *FFTWindow*
--- ***
--- Spectrum analysis windowing types.  Use this to reduce leakage of signals across frequency bands.
FFTWindow = {
	--- W[n] = 0.42 - (0.5 * COS(n/N) ) + (0.08 * COS(2.0 * n/N) ).
	Blackman = 0,
	--- W[n] = 0.35875 - (0.48829 * COS(1.0 * n/N)) + (0.14128 * COS(2.0 * n/N)) - (0.01168 * COS(3.0 * n/N)).
	BlackmanHarris = 1,
	--- W[n] = 0.54 - (0.46 * COS(n/N) ).
	Hamming = 2,
	--- W[n] = 0.5 * (1.0 - COS(n/N) ).
	Hanning = 3,
	--- W[n] = 1.0.
	Rectangular = 4,
	--- W[n] = TRI(2n/N).
	Triangle = 5
}

--- @enum AudioRolloffMode
--- ##### Enum *AudioRolloffMode*
--- ***
--- Rolloff modes that a 3D sound can have in an audio source.
AudioRolloffMode = {
	--- Use this when you want to use a custom rolloff.
	Custom = 0,
	--- Use this mode when you want to lower the volume of your sound over the distance.
	Linear = 1,
	--- Use this mode when you want a real-world rolloff.
	Logarithmic = 2
}

--- @enum AudioVelocityUpdateMode
--- ##### Enum *AudioVelocityUpdateMode*
--- ***
--- Describes when an AudioSource or AudioListener is updated.
AudioVelocityUpdateMode = {
	--- Updates the source or listener in the FixedUpdate loop if it is attached to a Rigidbody, dynamic Update otherwise.
	Auto = 0,
	--- Updates the source or listener in the dynamic Update loop.
	Dynamic = 1,
	--- Updates the source or listener in the FixedUpdate loop.
	Fixed = 2
}

--- @enum AudioSourceCurveType
--- ##### Enum *AudioSourceCurveType*
--- ***
--- This defines the curve type of the different custom curves that can be queried and set within the AudioSource.  The AudioSource can hold a number of custom distance curves, this enum is used within the AudioSource API to differentiate between them.
AudioSourceCurveType = {
	--- Custom Volume Rolloff.
	CustomRolloff = 0,
	--- Reverb Zone Mix.
	ReverbZoneMix = 1,
	--- The Spatial Blend.
	SpatialBlend = 2,
	--- The 3D Spread.
	Spread = 3
}

--- @enum AudioDataLoadState
--- ##### Enum *AudioDataLoadState*
--- ***
--- Value describing the current load state of the audio data associated with an AudioClip.
AudioDataLoadState = {
	--- Value returned by AudioClip.loadState for an AudioClip that has failed loading its audio data.
	Failed = 0,
	--- Value returned by AudioClip.loadState for an AudioClip that has succeeded loading its audio data.
	Loaded = 1,
	--- Value returned by AudioClip.loadState for an AudioClip that is currently loading audio data.
	Loading = 2,
	--- Value returned by AudioClip.loadState for an AudioClip that has no audio data loaded and where loading has not been initiated yet.
	Unloaded = 3
}

--- @enum AudioClipLoadType
--- ##### Enum *AudioClipLoadType*
--- ***
--- Determines how the audio clip is loaded in.
AudioClipLoadType = {
	--- The audio data of the clip will be kept in memory in compressed form.
	CompressedInMemory = 0,
	--- The audio data is decompressed when the audio clip is loaded.
	DecompressOnLoad = 1,
	--- Streams audio data from disk.
	Streaming = 2
}

--- @enum WeightedMode
--- ##### Enum *WeightedMode*
--- ***
--- Sets which weights to use when calculating curve segments.
WeightedMode = {
	--- Include inWeight and outWeight when calculating curve segments.
	Both = 0,
	--- Include inWeight when calculating the previous curve segment.
	In = 1,
	--- Exclude both inWeight or outWeight when calculating curve segments.
	None = 2,
	--- Include outWeight when calculating the next curve segment.
	Out = 3
}

--- @enum WrapMode
--- ##### Enum *WrapMode*
--- ***
--- Determines how time is treated outside of the keyframed range of an AnimationClip or AnimationCurve.
WrapMode = {
	--- Plays back the animation. When it reaches the end, it will keep playing the last frame and never stop playing.
	ClampForever = 0,
	--- Reads the default repeat mode set higher up.
	Default = 1,
	--- When time reaches the end of the animation clip, time will continue at the beginning.
	Loop = 2,
	--- When time reaches the end of the animation clip, the clip will automatically stop playing and time will be reset to beginning of the clip.
	Once = 3,
	--- When time reaches the end of the animation clip, time will ping pong back between beginning and end.
	PingPong = 4
}

--- @enum MixedLightingMode
--- ##### Enum *MixedLightingMode*
--- ***
--- Enum describing what lighting mode to be used with Mixed lights.<br> Check out [Unity MixedLightingMode](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/MixedLightingMode.html) form more information.
MixedLightingMode = {
	--- Mixed lights provide realtime direct lighting while indirect light is baked into lightmaps and light probes.
	IndirectOnly = 0,
	--- Mixed lights provide realtime direct lighting. Indirect lighting gets baked into lightmaps and light probes. Shadowmasks and light probe occlusion get generated for baked shadows. The Shadowmask Mode used at run time can be set in the Quality Settings panel.
	Shadowmask = 1,
	--- Mixed lights provide baked direct and indirect lighting for static objects. Dynamic objects receive realtime direct lighting and cast shadows on static objects using the main directional light in the Scene.
	Subtractive = 2
}

--- @enum TextureDimension
--- ##### Enum *TextureDimension*
--- ***
--- Texture "dimension" (type). <br> Indicates type of a texture (2D texture, cubemap, 3D volume texture etc.).<br> Check out [Unity TextureDimension](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/Rendering.TextureDimension.html)
TextureDimension = {
	--- Any texture type.
	Any = 0,
	--- Cubemap texture.
	Cube = 1,
	--- Cubemap array texture (CubemapArray).
	CubeArray = 2,
	--- No texture is assigned.
	None = 3,
	--- 2D texture (Texture2D).
	Tex2D = 4,
	--- 2D array texture (Texture2DArray).
	Tex2DArray = 5,
	--- 3D volume texture (Texture3D).
	Tex3D = 6,
	--- Texture type is not initialized or unknown.
	Unknown = 7
}

--- @enum FilterMode
--- ##### Enum *FilterMode*
--- ***
--- Filtering mode for textures. Corresponds to the settings in a texture inspector. <br>[Unity FilterMode](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/FilterMode.html)
FilterMode = {
	--- Bilinear filtering - texture samples are averaged.
	Bilinear = 0,
	--- Point filtering - texture pixels become blocky up close.
	Point = 1,
	--- Trilinear filtering - texture samples are averaged and also blended between mipmap levels.
	Trilinear = 2
}

--- @enum TextureWrapMode
--- ##### Enum *TextureWrapMode*
--- ***
--- Wrap mode for textures.[Unity TextureWrapMode](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/TextureWrapMode.html)
TextureWrapMode = {
	--- Clamps the texture to the last pixel at the edge.
	Clamp = 0,
	--- Tiles the texture, creating a repeating pattern by mirroring it at every integer boundary.
	Mirror = 1,
	--- Mirrors the texture once, then clamps to edge pixels.
	MirrorOnce = 2,
	--- Tiles the texture, creating a repeating pattern.
	Repeat = 3
}

--- @enum LightmapBakeType
--- ##### Enum *LightmapBakeType*
--- ***
--- Enum describing what part of a light contribution can be baked.<br> [Unity LightmapBakeType](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/LightmapBakeType.html)
LightmapBakeType = {
	--- Baked lights cannot move or change in any way during run time. All lighting for static objects gets baked into lightmaps. Lighting and shadows for dynamic objects gets baked into Light Probes.
	Baked = 0,
	--- Mixed lights allow a mix of realtime and baked lighting, based on the Mixed Lighting Mode used. These lights cannot move, but can change color and intensity at run time. Changes to color and intensity only affect direct lighting as indirect lighting gets baked. If using Subtractive mode, changes to color or intensity are not calculated at run time on static objects.
	Mixed = 1,
	--- Realtime lights cast run time light and shadows. They can change position, orientation, color, brightness, and many other properties at run time. No lighting gets baked into lightmaps or light probes.
	Realtime = 2
}

--- @enum LightRenderMode
--- ##### Enum *LightRenderMode*
--- ***
--- How the Light is rendered.
LightRenderMode = {
	--- Automatically choose the render mode.
	Auto = 0,
	--- Force the Light to be a pixel light.
	ForcePixel = 1,
	--- Force the Light to be a vertex light.
	ForceVertex = 2
}

--- @enum LightShadowResolution
--- ##### Enum *LightShadowResolution*
--- ***
--- Shadow resolution options for a Light.
LightShadowResolution = {
	--- Use resolution from QualitySettings (default).
	FromQualitySettings = 0,
	--- High shadow map resolution.
	High = 1,
	--- Low shadow map resolution.
	Low = 2,
	--- Medium shadow map resolution.
	Medium = 3,
	--- Very high shadow map resolution.
	VeryHigh = 4
}

--- @enum LightShadows
--- ##### Enum *LightShadows*
--- ***
--- Shadow casting options for a Light.
LightShadows = {
	--- Cast "hard" shadows (with no shadow filtering).
	Hard = 0,
	--- Do not cast shadows (default).
	None = 1,
	--- Cast "soft" shadows (with 4x PCF filtering).
	Soft = 2
}

--- @enum LightShape
--- ##### Enum *LightShape*
--- ***
--- Describes the shape of a spot light.
LightShape = {
	--- The shape of the spot light resembles a box oriented along the ray direction.
	Box = 0,
	--- The shape of the spot light resembles a cone. This is the default shape for spot lights.
	Cone = 1,
	--- The shape of the spotlight resembles a pyramid or frustum. You can use this to simulate a screening or barn door effect on a normal spotlight.
	Pyramid = 2
}

--- @enum LightType
--- ##### Enum *LightType*
--- ***
--- The type of a Light.
LightType = {
	--- The light is a directional light.
	Directional = 0,
	--- The light is a disc shaped area light. It affects only baked lightmaps and lightprobes.
	Disc = 1,
	--- The light is a point light.
	Point = 2,
	--- The light is a rectangle shaped area light. It affects only baked lightmaps and lightprobes.
	Rectangle = 3,
	--- The light is a spot light.
	Spot = 4
}

--- @enum VideoStatus
--- ##### Enum *VideoStatus*
--- ***
--- Defines the state of a video if it is playing, paused, or stopped. 
VideoStatus = {
	--- Video is not playing. It is either stopped or in idle. 
	Idle = 0,
	--- Video is paused. 
	Paused = 1,
	--- Video is playing.
	Playing = 2
}

--- @enum DirectorWrapMode
--- ##### Enum *DirectorWrapMode*
--- ***
--- Wrap mode for Playables.<br> [Unity DirectorWrapMode](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/Playables.DirectorWrapMode.html)
DirectorWrapMode = {
	--- Hold the last frame when the playable time reaches it's duration.
	Hold = 0,
	--- Loop back to zero time and continue playing.
	Loop = 1,
	--- Do not keep playing when the time reaches the duration.
	None = 2
}

--- @enum PlayState
--- ##### Enum *PlayState*
--- ***
--- Status of a Playable.<br> [Unity PlayState](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/Playables.PlayState.html)
PlayState = {
	--- The Playable has been paused. Its local time will not advance.
	Paused = 0,
	--- The Playable is currently Playing.
	Playing = 1
}

--- @enum DirectorUpdateMode
--- ##### Enum *DirectorUpdateMode*
--- ***
--- Defines what time source is used to update a Director graph.<br> [Unity DirectorUpdateMode](https://docs.unity3d.com/2019.3/Documentation/ScriptReference/Playables.DirectorUpdateMode.html)
DirectorUpdateMode = {
	--- Update is based on DSP (Digital Sound Processing) clock. Use this for graphs that need to be synchronized with Audio.
	DSPClock = 0,
	--- Update is based on Time.time. Use this for graphs that need to be synchronized on gameplay, and that need to be paused when the game is paused.
	GameTime = 1,
	--- Update mode is manual. You need to manually call PlayableGraph.Evaluate with your own deltaTime. This can be useful for graphs that are completely disconnected from the rest of the game. For example, localized bullet time.
	Manual = 2,
	--- Update is based on Time.unscaledTime. Use this for graphs that need to be updated even when gameplay is paused. Example: Menus transitions need to be updated even when the game is paused.
	UnscaledGameTime = 3
}

--- @enum TextAlignment
--- ##### Enum *TextAlignment*
--- ***
--- How multiline text should be aligned.This is used by the TextMesh.alignment property.
TextAlignment = {
	--- Text lines are centered.
	Center = 0,
	--- Text lines are aligned on the left side.
	Left = 1,
	--- Text lines are aligned on the right side.
	Right = 2
}

--- @enum TextAnchor
--- ##### Enum *TextAnchor*
--- ***
--- Where the anchor of the text is placed. This is used by TextMesh.anchor property.
TextAnchor = {
	--- Text is anchored in lower side, centered horizontally.
	LowerCenter = 0,
	--- Text is anchored in lower left corner.
	LowerLeft = 1,
	--- Text is anchored in lower right corner.
	LowerRight = 2,
	--- Text is centered both horizontally and vertically.
	MiddleCenter = 3,
	--- Text is anchored in left side, centered vertically.
	MiddleLeft = 4,
	--- Text is anchored in right side, centered vertically.
	MiddleRight = 5,
	--- Text is anchored in upper side, centered horizontally.
	UpperCenter = 6,
	--- Text is anchored in upper left corner.
	UpperLeft = 7,
	--- Text is anchored in upper right corner.
	UpperRight = 8
}

--- @enum FontStyle
--- ##### Enum *FontStyle*
--- ***
--- Font Style applied to GUI Texts, Text Meshes or GUIStyles.
FontStyle = {
	--- Bold style applied to your texts.
	Bold = 0,
	--- Bold and Italic styles applied to your texts.
	BoldAndItalic = 1,
	--- Italic style applied to your texts.
	Italic = 2,
	--- No special style is applied.
	Normal = 3
}

--- @enum PortalBehavior
--- ##### Enum *PortalBehavior*
--- ***
--- Defines how a portal should behave in terms of instances of the world.   
PortalBehavior = {
	--- Will create a new instance and join it every time. This is not a recommended portal behavior. Use JoinAny instead.   
	Create = 0,
	--- Will try to join any available instance of the world in defined region. It will create a new instance if no none is available. This is the recommended behavior for any portal.
	JoinAny = 1,
	--- Will join a specific instance with given instance id. Use this only if you are addressing to an persistence instance. 
	JoinSpecific = 2
}

--- @enum MaterialGlobalIlluminationFlags
--- ##### Enum *MaterialGlobalIlluminationFlags*
--- ***
--- How the material interacts with lightmaps and lightprobes.
MaterialGlobalIlluminationFlags = {
	--- Helper Mask to be used to query the enum only based on whether realtime GI or baked GI is set, ignoring all other bits.
	AnyEmissive = 0,
	--- The emissive lighting affects baked Global Illumination. It emits lighting into baked lightmaps and baked lightprobes.
	BakedEmissive = 1,
	--- The emissive lighting is guaranteed to be black. This lets the lightmapping system know that it doesn't have to extract emissive lighting information from the material and can simply assume it is completely black.
	EmissiveIsBlack = 2,
	--- The emissive lighting does not affect Global Illumination at all.
	None = 3,
	--- The emissive lighting will affect realtime Global Illumination. It emits lighting into realtime lightmaps and realtime lightprobes.
	RealtimeEmissive = 4
}

--- @enum LightProbeUsage
--- ##### Enum *LightProbeUsage*
--- ***
--- Light probe interpolation type.
LightProbeUsage = {
	--- Simple light probe interpolation is used.
	BlendProbes = 0,
	--- The light probe shader uniform values are extracted from the material property block set on the renderer.
	CustomProvided = 1,
	--- Light Probes are not used. The Scene's ambient probe is provided to the shader.
	Off = 2,
	--- Uses a 3D grid of interpolated light probes.
	UseProxyVolume = 3
}

--- @enum MotionVectorGenerationMode
--- ##### Enum *MotionVectorGenerationMode*
--- ***
--- The type of motion vectors that should be generated.
MotionVectorGenerationMode = {
	--- Use only camera movement to track motion.
	Camera = 0,
	--- Do not track motion. Motion vectors will be 0.
	ForceNoMotion = 1,
	--- Use a specific pass (if required) to track motion.
	Object = 2
}

--- @enum ReflectionProbeUsage
--- ##### Enum *ReflectionProbeUsage*
--- ***
--- Reflection Probe usage.
ReflectionProbeUsage = {
	--- Reflection probes are enabled. Blending occurs only between probes, useful in indoor environments. The renderer will use default reflection if there are no reflection probes nearby, but no blending between default reflection and probe will occur.
	BlendProbes = 0,
	--- Reflection probes are enabled. Blending occurs between probes or probes and default reflection, useful for outdoor environments.
	BlendProbesAndSkybox = 1,
	--- Reflection probes are disabled, skybox will be used for reflection.
	Off = 2,
	--- Reflection probes are enabled, but no blending will occur between probes when there are two overlapping volumes.
	Simple = 3
}

--- @enum shadowCastingMode
--- ##### Enum *shadowCastingMode*
--- ***
--- How shadows are cast from this object.
shadowCastingMode = {
	--- No shadows are cast from this object.
	Off = 0,
	--- Shadows are cast from this object.
	On = 1,
	--- Object casts shadows, but is otherwise invisible in the Scene.
	ShadowsOnly = 2,
	--- Shadows are cast from this object, treating it as two-sided.
	TwoSided = 3
}

--- @enum AmbientMode
--- ##### Enum *AmbientMode*
--- ***
--- Ambient lighting mode.
AmbientMode = {
	--- Ambient lighting is defined by a custom cubemap.
	Custom = 0,
	--- Flat ambient lighting.
	Flat = 1,
	--- Skybox-based or custom ambient lighting.
	Skybox = 2,
	--- Trilight ambient lighting.
	Trilight = 3
}

--- @enum FogMode
--- ##### Enum *FogMode*
--- ***
--- Fog mode to use.
FogMode = {
	--- Exponential fog.
	Exponential = 0,
	--- Exponential squared fog (default).
	ExponentialSquared = 1,
	--- Linear fog.
	Linear = 2
}

--- @enum LineAlignment
--- ##### Enum *LineAlignment*
--- ***
--- Control the direction lines face, when using the LineRenderer or TrailRenderer.
LineAlignment = {
	--- Lines face the Z axis of the Transform Component.
	TransformZ = 0,
	--- Lines face the camera.
	View = 1
}

--- @enum LineTextureMode
--- ##### Enum *LineTextureMode*
--- ***
--- Choose how textures are applied to Lines and Trails.
LineTextureMode = {
	--- Map the texture once along the entire length of the line, assuming all vertices are evenly spaced.
	DistributePerSegment = 0,
	--- Repeat the texture along the line, repeating at a rate of once per line segment. To adjust the tiling rate, use Material.SetTextureScale.
	RepeatPerSegment = 1,
	--- Map the texture once along the entire length of the line.
	Stretch = 2,
	--- Repeat the texture along the line, based on its length in world units. To set the tiling rate, use Material.SetTextureScale.
	Tile = 3
}

--- @enum NavMeshPathStatus
--- ##### Enum *NavMeshPathStatus*
--- ***
--- Status of path.
NavMeshPathStatus = {
	--- The path terminates at the destination.
	PathComplete = 0,
	--- The path is invalid.
	PathInvalid = 1,
	--- The path cannot reach the destination.
	PathPartial = 2
}

--- @enum OffMeshLinkType
--- ##### Enum *OffMeshLinkType*
--- ***
--- Link type specifier.
OffMeshLinkType = {
	--- Vertical drop.
	LinkTypeDropDown = 0,
	--- Horizontal jump.
	LinkTypeJumpAcross = 1,
	--- Manually specified type of link.
	LinkTypeManual = 2
}

--- @enum ObstacleAvoidanceType
--- ##### Enum *ObstacleAvoidanceType*
--- ***
--- Level of obstacle avoidance.
ObstacleAvoidanceType = {
	--- Good avoidance. High performance impact.
	GoodQualityObstacleAvoidance = 0,
	--- Enable highest precision. Highest performance impact.
	HighQualityObstacleAvoidance = 1,
	--- Enable simple avoidance. Low performance impact.
	LowQualityObstacleAvoidance = 2,
	--- Medium avoidance. Medium performance impact.
	MedQualityObstacleAvoidance = 3,
	--- Disable avoidance.
	NoObstacleAvoidance = 4
}

--- @enum VideoAspectRatio
--- ##### Enum *VideoAspectRatio*
--- ***
--- Methods used to fit a video in the target area.
VideoAspectRatio = {
	--- Resize proportionally so that width fits the target area, cropping or adding black bars above and below if needed.
	FitHorizontally = 0,
	--- Resize proportionally so that content fits the target area, adding black bars if needed.
	FitInside = 1,
	--- Resize proportionally so that content fits the target area, cropping if needed.
	FitOutside = 2,
	--- Resize proportionally so that height fits the target area, cropping or adding black bars on each side if needed.
	FitVertically = 3,
	--- Preserve the pixel size without adjusting for target area.
	NoScaling = 4,
	--- Resize non-proportionally to fit the target area.
	Stretch = 5
}

--- @enum VideoAudioOutputMode
--- ##### Enum *VideoAudioOutputMode*
--- ***
--- Places where the audio embedded in a video can be sent.
VideoAudioOutputMode = {
	--- Send the embedded audio to the associated AudioSampleProvider.
	APIOnly = 0,
	--- Send the embedded audio into a specified AudioSource.
	AudioSource = 1,
	--- Send the embedded audio direct to the platform's audio hardware.
	Direct = 2,
	--- Disable the embedded audio.
	None = 3
}

--- @enum VideoRenderMode
--- ##### Enum *VideoRenderMode*
--- ***
--- Type of destination for the images read by a VideoPlayer.
VideoRenderMode = {
	--- Don't draw the video content anywhere, but still make it available via the VideoPlayer's texture property in the API.
	APIOnly = 0,
	--- Draw video content behind a camera's Scene.
	CameraFarPlane = 1,
	--- Draw video content in front of a camera's Scene.
	CameraNearPlane = 2,
	--- Draw the video content into a user-specified property of the current GameObject's material.
	MaterialOverride = 3,
	--- Draw video content into a RenderTexture.
	RenderTexture = 4
}

--- @enum VideoSource
--- ##### Enum *VideoSource*
--- ***
--- Source of the video content for a VideoPlayer.
VideoSource = {
	--- Use the current URL as the video content source.
	Url = 0,
	--- Use the current clip as the video content source.
	VideoClip = 1
}

--- @enum VideoTimeReference
--- ##### Enum *VideoTimeReference*
--- ***
--- The clock that the VideoPlayer observes to detect and correct drift.
VideoTimeReference = {
	--- External reference clock the VideoPlayer observes to detect and correct drift.
	ExternalTime = 0,
	--- Disables the drift detection.
	Freerun = 1,
	--- Internal reference clock the VideoPlayer observes to detect and correct drift.
	InternalTime = 2
}

--- @enum VideoTimeSource
--- ##### Enum *VideoTimeSource*
--- ***
--- Time source followed by the VideoPlayer when reading content.
VideoTimeSource = {
	--- The audio hardware clock.
	AudioDSPTimeSource = 0,
	--- The unscaled game time as defined by Time.realtimeSinceStartup.
	GameTimeSource = 1
}

--- @enum EventTarget
--- ##### Enum *EventTarget*
--- ***
--- The invocation target for invoking Lua Events.
EventTarget = {
	--- Every client, including the sender.
	All = 0,
	--- Only the master client
	Master = 1,
	--- Only the current player. Same as Invoke.
	OnlyThisClient = 2,
	--- Everyone except current player. Others.
	Others = 3,
	--- A specific set of players. If player set is nil, then same behavior as All.
	Player = 4
}

--- @enum AvatarIKGoal
--- ##### Enum *AvatarIKGoal*
--- ***
--- IK Goal.
AvatarIKGoal = {
	--- The left foot.
	LeftFoot = 0,
	--- The left hand.
	LeftHand = 1,
	--- The right foot.
	RightFoot = 2,
	--- The right hand.
	RightHand = 3
}

--- @enum AvatarIKHint
--- ##### Enum *AvatarIKHint*
--- ***
--- IK Hint.
AvatarIKHint = {
	--- The left elbow IK hint.
	LeftElbow = 0,
	--- The left knee IK hint.
	LeftKnee = 1,
	--- The right elbow IK hint.
	RightElbow = 2,
	--- The right knee IK hint.
	RightKnee = 3
}

--- @enum AnimatorCullingMode
--- ##### Enum *AnimatorCullingMode*
--- ***
--- Culling mode for the Animator.
AnimatorCullingMode = {
	--- Always animate the entire character. Object is animated even when offscreen.
	AlwaysAnimate = 0,
	--- Animation is completely disabled when renderers are not visible.
	CullCompletely = 1,
	--- Retarget, IK and write of Transforms are disabled when renderers are not visible.
	CullUpdateTransforms = 2
}

--- @enum AnimatorControllerParameterType
--- ##### Enum *AnimatorControllerParameterType*
--- ***
--- The type of the parameter.
AnimatorControllerParameterType = {
	--- Boolean type parameter.
	Bool = 0,
	--- Float type parameter.
	Float = 1,
	--- Int type parameter.
	Int = 2,
	--- Trigger type parameter.
	Trigger = 3
}

--- @enum AnimationBlendMode
--- ##### Enum *AnimationBlendMode*
--- ***
--- Used by Animation.Play function.
AnimationBlendMode = {
	--- Animations will be added.
	Additive = 0,
	--- Animations will be blended.
	Blend = 1
}

--- @enum AnimatorUpdateMode
--- ##### Enum *AnimatorUpdateMode*
--- ***
--- The update mode of the Animator.
AnimatorUpdateMode = {
	--- Updates the animator during the physic loop in order to have the animation system synchronized with the physics engine.
	AnimatePhysics = 0,
	--- Normal update of the animator.
	Normal = 1,
	--- Animator updates independently of Time.timeScale.
	UnscaledTime = 2
}

--- @enum DurationUnit
--- ##### Enum *DurationUnit*
--- ***
--- Describe the unit of a duration.
DurationUnit = {
	--- A fixed duration is a duration expressed in seconds.
	Fixed = 0,
	--- A normalized duration is a duration expressed in percentage.
	Normalized = 1
}

--- @enum HumanBodyBones
--- ##### Enum *HumanBodyBones*
--- ***
--- Human Body Bones.
HumanBodyBones = {
	--- This is the Chest bone.
	Chest = 0,
	--- This is the Head bone.
	Head = 1,
	--- This is the Hips bone.
	Hips = 2,
	--- This is the Jaw bone.
	Jaw = 3,
	--- This is the Last bone index delimiter.
	LastBone = 4,
	--- This is the Left Eye bone.
	LeftEye = 5,
	--- This is the Left Ankle bone.
	LeftFoot = 6,
	--- This is the Left Wrist bone.
	LeftHand = 7,
	--- This is the left index 3rd phalange.
	LeftIndexDistal = 8,
	--- This is the left index 2nd phalange.
	LeftIndexIntermediate = 9,
	--- This is the left index 1st phalange.
	LeftIndexProximal = 10,
	--- This is the left little 3rd phalange.
	LeftLittleDistal = 11,
	--- This is the left little 2nd phalange.
	LeftLittleIntermediate = 12,
	--- This is the left little 1st phalange.
	LeftLittleProximal = 13,
	--- This is the Left Elbow bone.
	LeftLowerArm = 14,
	--- This is the Left Knee bone.
	LeftLowerLeg = 15,
	--- This is the left middle 3rd phalange.
	LeftMiddleDistal = 16,
	--- This is the left middle 2nd phalange.
	LeftMiddleIntermediate = 17,
	--- This is the left middle 1st phalange.
	LeftMiddleProximal = 18,
	--- This is the left ring 3rd phalange.
	LeftRingDistal = 19,
	--- This is the left ring 2nd phalange.
	LeftRingIntermediate = 20,
	--- This is the left ring 1st phalange.
	LeftRingProximal = 21,
	--- This is the Left Shoulder bone.
	LeftShoulder = 22,
	--- This is the left thumb 3rd phalange.
	LeftThumbDistal = 23,
	--- This is the left thumb 2nd phalange.
	LeftThumbIntermediate = 24,
	--- This is the left thumb 1st phalange.
	LeftThumbProximal = 25,
	--- This is the Left Toes bone.
	LeftToes = 26,
	--- This is the Left Upper Arm bone.
	LeftUpperArm = 27,
	--- This is the Left Upper Leg bone.
	LeftUpperLeg = 28,
	--- This is the Neck bone.
	Neck = 29,
	--- This is the Right Eye bone.
	RightEye = 30,
	--- This is the Right Ankle bone.
	RightFoot = 31,
	--- This is the Right Wrist bone.
	RightHand = 32,
	--- This is the right index 3rd phalange.
	RightIndexDistal = 33,
	--- This is the right index 2nd phalange.
	RightIndexIntermediate = 34,
	--- This is the right index 1st phalange.
	RightIndexProximal = 35,
	--- This is the right little 3rd phalange.
	RightLittleDistal = 36,
	--- This is the right little 2nd phalange.
	RightLittleIntermediate = 37,
	--- This is the right little 1st phalange.
	RightLittleProximal = 38,
	--- This is the Right Elbow bone.
	RightLowerArm = 39,
	--- This is the Right Knee bone.
	RightLowerLeg = 40,
	--- This is the right middle 3rd phalange.
	RightMiddleDistal = 41,
	--- This is the right middle 2nd phalange.
	RightMiddleIntermediate = 42,
	--- This is the right middle 1st phalange.
	RightMiddleProximal = 43,
	--- This is the right ring 3rd phalange.
	RightRingDistal = 44,
	--- This is the right ring 2nd phalange.
	RightRingIntermediate = 45,
	--- This is the right ring 1st phalange.
	RightRingProximal = 46,
	--- This is the Right Shoulder bone.
	RightShoulder = 47,
	--- This is the right thumb 3rd phalange.
	RightThumbDistal = 48,
	--- This is the right thumb 2nd phalange.
	RightThumbIntermediate = 49,
	--- This is the right thumb 1st phalange.
	RightThumbProximal = 50,
	--- This is the Right Toes bone.
	RightToes = 51,
	--- This is the Right Upper Arm bone.
	RightUpperArm = 52,
	--- This is the Right Upper Leg bone.
	RightUpperLeg = 53,
	--- This is the first Spine bone.
	Spine = 54,
	--- This is the Upper Chest bone.
	UpperChest = 55
}

--- @enum AvatarTarget
--- ##### Enum *AvatarTarget*
--- ***
--- Target avatar body part.
AvatarTarget = {
	--- The body, center of mass.
	Body = 0,
	--- The left foot.
	LeftFoot = 1,
	--- The left hand.
	LeftHand = 2,
	--- The right foot.
	RightFoot = 3,
	--- The right hand.
	RightHand = 4,
	--- The root, the position of the game object.
	Root = 5
}

--- @enum WindZoneMode
--- ##### Enum *WindZoneMode*
--- ***
--- Modes a Wind Zone can have, either Spherical or Directional. [Unity WindZoneMode](https://docs.unity3d.com/ScriptReference/WindZoneMode.html)
WindZoneMode = {
	--- Wind zone affects the entire Scene in one direction.
	Directional = 0,
	--- Wind zone only has an effect inside the radius, and has a falloff from the center towards the edge.
	Spherical = 1
}

--- @enum PromiseState
--- ##### Enum *PromiseState*
--- ***
--- State of a promise object.
PromiseState = {
	--- The execution of asynchronous function resulted in an error.
	Error = 0,
	--- The promise successfully completed the asynchronous function
	Fulfilled = 1,
	--- Default promise state.
	None = 2,
	--- Execution of asynchronous function started, but yet to be completed.
	Pending = 3,
	--- The promise is rejected.
	Rejected = 4
}

--- @enum VariableSubject
--- ##### Enum *VariableSubject*
--- ***
--- The subject which cloud variables are associated with.
VariableSubject = {
	--- A server
	Server = 0,
	--- A User
	User = 1,
	--- A world
	World = 2
}

--- @enum MIDIFunction
--- ##### Enum *MIDIFunction*
--- ***
--- Available MIDI Message functions based on MIDI specifications. 
MIDIFunction = {
	--- Channel pressure
	CHANNEL_PRESSURE = 0,
	--- Control change
	CONTROL_CHANGE = 1,
	--- Note off
	NOTE_OFF = 2,
	--- Note On
	NOTE_ON = 3,
	--- pitch bend
	PITCH_BEND = 4,
	--- Polyphonic pressure.
	POLYPHONIC_PRESSURE = 5,
	--- Program change
	PROGRAM_CHANGE = 6,
	--- System
	SYSTEM = 7
}
